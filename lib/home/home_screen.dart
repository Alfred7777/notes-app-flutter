import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/resources/app_paddings.dart';
import 'package:notes_app/resources/app_text_styles.dart';
import 'package:notes_app/widgets/note_archive_dialog.dart';
import 'package:notes_app/widgets/note_card.dart';
import 'dart:async';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'package:notes_app/repositories/note_repository.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/note/note_screen.dart';
import 'package:notes_app/widgets/note_search_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final NoteRepository noteRepository = NoteRepository();
  late HomeBloc _homeBloc;

  late TextEditingController _textFilterController;
  late TextEditingController _dateFilterController;
  late TabController _tabController;
  bool _stateFilter = false;

  // ignore: unused_field
  late Timer _debounce;
  final int _debouncetime = 500;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      notesRepository: noteRepository,
    );

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    _textFilterController = TextEditingController();
    _textFilterController.addListener(_onQueryChanged);

    _dateFilterController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textFilterController.dispose();
    _dateFilterController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  void _refreshNotes() {
    _homeBloc.add(
      FetchNotes(
        textFilter: _textFilterController.text.length > 3 ? _textFilterController.text : '',
        dateFilter: _dateFilterController.text,
        stateFilter: _stateFilter,
      ),
    );
  }

  void _onCreateNote() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => NoteScreen(
          note: Note.empty(),
        ),
      ),
    );

    if (result != null) {
      _refreshNotes();
    }
  }

  void _onEditNote(Note note) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => NoteScreen(note: note),
      ),
    );

    if (result != null) {
      _refreshNotes();
    }
  }

  void _onArchiveNote(int noteID) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return NoteArchiveDialog(
          noteID: noteID, 
          archiveNote: (int noteID) {
            _homeBloc.add(ArchiveNote(noteID: noteID));
            _refreshNotes();
          },
        );
      },
    );
  }

  void _onQueryChanged() {
    //if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      if (_homeBloc.state is HomeReady) {
        _refreshNotes();
      }
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          _stateFilter = false;
          break;
        case 1:
          _stateFilter = true;
          break;
      }
      _refreshNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: AppColors.kMainAccentColor,
            labelStyle: AppTextStyles.kTabBarLabelStyle,
            labelColor: AppColors.kMainAccentColor,
            unselectedLabelColor: AppColors.kPrimaryColor,
            tabs: const [
              Tab(
                text: 'Notes',
              ),
              Tab(
                text: 'Archive',
              ),
            ],
          ),
          backgroundColor: AppColors.kMainBackgroundColor,
          body: BlocConsumer(
            bloc: _homeBloc,
            listener: (context, state) {
              if (state is HomeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: AppColors.kSecondAccentColor,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is HomeUninitialized) {
                _homeBloc.add(
                  FetchNotes(
                    textFilter: _textFilterController.text,
                    dateFilter: _dateFilterController.text,
                    stateFilter: _stateFilter,
                  ),
                );
              }
              if (state is HomeReady) {
                return Column(
                  children: [
                    NoteSearchBar(
                      queryTextController: _textFilterController,
                    ),
                    Flexible(
                      child: MasonryGridView.count(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPaddings.kNoteCardPadding,
                          horizontal: AppPaddings.kNoteCardPadding * 2,
                        ),
                        mainAxisSpacing: AppPaddings.kNoteCardPadding,
                        crossAxisSpacing: AppPaddings.kNoteCardPadding,
                        crossAxisCount: 2,
                        itemCount: state.noteList.length,
                        itemBuilder: (context, index) {
                          return NoteCard(
                            note: state.noteList[index], 
                            editNote: _onEditNote, 
                            archiveNote: _onArchiveNote,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.grey.shade100,
                ),
              );
            }
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.kMainAccentColor,
            onPressed: () => _onCreateNote(),
            child: const Icon(
              Icons.add,
              color: AppColors.kMainBackgroundColor,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Notatki'),
  //       actions: [
  //         IconButton(
  //           icon: const Icon(Icons.filter_list),
  //           iconSize: 32.0,
  //           onPressed: () {},
  //         ),
  //       ],
  //       centerTitle: true,
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       child: const Icon(Icons.add),
  //       onPressed: () => _onCreateNote(),
  //     ),
  //     body: BlocConsumer(
  //       bloc: _homeBloc,
  //       listener: (context, state) {
  //         if (state is HomeError) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(state.error),
  //               backgroundColor: Colors.red.shade800,
  //             ),
  //           );
  //         }
  //       },
  //       builder: (context, state) {
  //         if (state is HomeUninitialized) {
  //           _homeBloc.add(
  //             FetchNotes(
  //               textFilter: _textFilterController.text,
  //               dateFilter: _dateFilterController.text,
  //               stateFilter: _stateFilter,
  //             ),
  //           );
  //         }
  //         if (state is HomeReady) {
  //           return Column(
  //             children: [
  //               TextField(
  //                 controller: _textFilterController,
  //                 decoration: const InputDecoration(
  //                   hintText: 'Wyszukaj',
  //                 ),
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   Flexible(
  //                     child: TextField(
  //                       controller: _dateFilterController,
  //                       readOnly: true,
  //                       textAlign: TextAlign.center,
  //                       onTap: () async {
  //                         DateTime? pickedDate = await showDatePicker(
  //                           context: context, 
  //                           initialDate: DateTime.now(),
  //                           firstDate: DateTime(1980),
  //                           lastDate: DateTime(DateTime.now().year + 1),
  //                         );
  //                         if (pickedDate != null) {
  //                           String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
  //                           setState(() {
  //                             _dateFilterController.text = formattedDate;
  //                             _onFiltersChanged();
  //                           });
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                   Flexible(
  //                     child: DropdownButton<int>(
  //                       value: _stateFilter,
  //                       onChanged: (value) {
  //                         setState(() {
  //                           _stateFilter = value!;
  //                           _onFiltersChanged();
  //                         });
  //                       },
  //                       items: [-1, 0, 1, 2].map<DropdownMenuItem<int>>((int value) {
  //                         List<String> textValues = ['Wszystkie', 'W edycji', 'Zatwierdzona', 'Zarchiwizowana'];
  //                         return DropdownMenuItem<int>(
  //                           value: value,
  //                           child: Text(textValues[value + 1]),
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: state.noteList.length,
  //                   itemBuilder: (context, index) {
  //                     return NoteBar(
  //                       index: index,
  //                       note: state.noteList[index],
  //                       onDoubleTap: _onEditNote,
  //                       onButtonPressed: _onArchiveNote,
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           );
  //         }
  //         return Center(
  //           child: CircularProgressIndicator(
  //             color: Colors.grey.shade100,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}
