import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/repositories/notes_repository.dart';
import 'package:notes_app/widgets/note_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String route = '/';

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final notesRepository = NotesRepository();
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = HomeBloc(
      notesRepository: notesRepository,
    );
  }

  void _onCreateNote() {
    
  }

  void _onArchiveNote(int noteID) {
    
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
            _homeBloc.add(FetchNotes());
          }
          if (state is HomeReady) {
            return ListView.builder(
              itemCount: state.noteList.length,
              itemBuilder: (context, index) {
                return NoteBar(
                  index: index,
                  note: state.noteList[index],
                  onTap: _onArchiveNote,
                  onDoubleTap: _onArchiveNote,
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
