import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/note/note_screen.dart';
import 'package:notes_app/repositories/note_repository.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/widgets/note_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final NoteRepository noteRepository = NoteRepository();
  late HomeBloc _homeBloc;

  late TextEditingController _textFilterController;
  late TextEditingController _dateFilterController;
  int _stateFilter = -1;

  late Timer _debounce;
  final int _debouncetime = 500;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      notesRepository: noteRepository,
    );

    _textFilterController = TextEditingController();
    _textFilterController.addListener(_onQueryChanged);

    _dateFilterController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  @override
  void dispose() {
    _textFilterController.dispose();
    _dateFilterController.dispose();
    _homeBloc.close();
    super.dispose();
  }

  void _onCreateNote() async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const NoteScreen(
          note: Note(
            id: -1,
            title: '',
            content: '',
            creationDate: '',
            isArchived: false,
          ),
        ),
      ),
    );

    if (result != null) {
      _homeBloc.add(
        FetchNotes(
          textFilter: _textFilterController.text,
          dateFilter: _dateFilterController.text,
          stateFilter: _stateFilter,
        ),
      );
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
      _homeBloc.add(
        FetchNotes(
          textFilter: _textFilterController.text,
          dateFilter: _dateFilterController.text,
          stateFilter: _stateFilter,
        ),
      );
    }
  }

  void _onArchiveNote(int noteID) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Archiwizuj notatkę'),
          content: const Text('Czy chcesz zarchiwizować tę notatkę?'),
          actions: <Widget>[
            TextButton(
              child: Text('Tak', style: TextStyle(color: Colors.grey.shade100)),
              onPressed: () {
                Navigator.of(context).pop();
                _homeBloc.add(ArchiveNote(noteID: noteID));
                _homeBloc.add(
                  FetchNotes(
                    textFilter: _textFilterController.text,
                    dateFilter: _dateFilterController.text,
                    stateFilter: _stateFilter,
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Nie', style: TextStyle(color: Colors.grey.shade100)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onFiltersChanged() {
    _homeBloc.add(
      FetchNotes(
        textFilter: _textFilterController.text,
        dateFilter: _dateFilterController.text,
        stateFilter: _stateFilter,
      ),
    );
  }

  void _onQueryChanged() {
    //if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: _debouncetime), () {
      if (_textFilterController.text.length > 3) {
        if (_homeBloc.state is HomeReady) {
          _homeBloc.add(
            FetchNotes(
              textFilter: _textFilterController.text,
              dateFilter: _dateFilterController.text,
              stateFilter: _stateFilter,
            ),
          );
        }
      } else {
        _homeBloc.add(
          FetchNotes(
            textFilter: '',
            dateFilter: _dateFilterController.text,
            stateFilter: _stateFilter,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notatki'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            iconSize: 32.0,
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _onCreateNote(),
      ),
      body: BlocConsumer(
        bloc: _homeBloc,
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red.shade800,
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
                TextField(
                  controller: _textFilterController,
                  decoration: const InputDecoration(
                    hintText: 'Wyszukaj',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _dateFilterController,
                        readOnly: true,
                        textAlign: TextAlign.center,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context, 
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1980),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate); 
                            setState(() {
                              _dateFilterController.text = formattedDate;
                              _onFiltersChanged();
                            });
                          }
                        },
                      ),
                    ),
                    Flexible(
                      child: DropdownButton<int>(
                        value: _stateFilter,
                        onChanged: (value) {
                          setState(() {
                            _stateFilter = value!;
                            _onFiltersChanged();
                          });
                        },
                        items: [-1, 0, 1, 2].map<DropdownMenuItem<int>>((int value) {
                          List<String> textValues = ['Wszystkie', 'W edycji', 'Zatwierdzona', 'Zarchiwizowana'];
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(textValues[value + 1]),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.noteList.length,
                    itemBuilder: (context, index) {
                      return NoteBar(
                        index: index,
                        note: state.noteList[index],
                        onDoubleTap: _onEditNote,
                        onButtonPressed: _onArchiveNote,
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
        },
      ),
    );
  }
}
