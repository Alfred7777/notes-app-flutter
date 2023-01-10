import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/note/note_screen.dart';
import 'package:notes_app/repositories/note_repository.dart';
import 'package:notes_app/widgets/note_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final NoteRepository noteRepository = NoteRepository();
  late HomeBloc _homeBloc;

  final String _textFilter = '';
  final String _dateFilter = '';
  final int _stateFilter = -1;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      notesRepository: noteRepository,
    );
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
            state: 0,
          ),
        ),
      ),
    );

    if (result != null) {
      _homeBloc.add(
        FetchNotes(
          textFilter: _textFilter,
          dateFilter: _dateFilter,
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
          textFilter: _textFilter,
          dateFilter: _dateFilter,
          stateFilter: _stateFilter,
        ),
      );
    }
  }

  void _onArchiveNote(int noteID) {
    _homeBloc.add(ArchiveNote(noteID: noteID));
    _homeBloc.add(
      FetchNotes(
        textFilter: _textFilter,
        dateFilter: _dateFilter,
        stateFilter: _stateFilter,
      ),
    );
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

          }
        },
        builder: (context, state) {
          if (state is HomeUninitialized) {
            _homeBloc.add(
              FetchNotes(
                textFilter: _textFilter,
                dateFilter: _dateFilter,
                stateFilter: _stateFilter,
              ),
            );
          }
          if (state is HomeReady) {
            return ListView.builder(
              itemCount: state.noteList.length,
              itemBuilder: (context, index) {
                return NoteBar(
                  index: index,
                  note: state.noteList[index],
                  onDoubleTap: _onEditNote,
                  onButtonPressed: _onArchiveNote,
                );
              },
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
