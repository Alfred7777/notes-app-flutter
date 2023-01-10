import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import 'package:notes_app/repositories/note_repository.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  
  const NoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteScreen> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  final NoteRepository noteRepository = NoteRepository();
  late NoteBloc _noteBloc;

  @override
  void initState() {
    super.initState();
    _noteBloc = NoteBloc(
      notesRepository: noteRepository,
      note: widget.note,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notatka'),
        centerTitle: true,
      ),
      body: BlocConsumer(
        bloc: _noteBloc,
        listener: (context, state) {
          if (state is NoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red.shade800,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is NoteInitial) {
            return Column();
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