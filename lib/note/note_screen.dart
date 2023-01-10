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

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  final _noteFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _noteBloc = NoteBloc(
      notesRepository: noteRepository,
      note: widget.note,
    );

    _titleController = TextEditingController(
      text: widget.note.title,
    );
    _contentController = TextEditingController(
      text: widget.note.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _noteBloc.close();
    super.dispose();
  }

  void _saveNote() {
    if (_noteFormKey.currentState!.validate()) {
      _noteBloc.add(
        SaveNote(
          noteID: widget.note.id,
          noteTitle: _titleController.text, 
          noteContent: _contentController.text,
        ),
      );
    }
  }

  void _archiveNote() async {
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
                _noteBloc.add(
                  ArchiveNote(noteID: widget.note.id),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.note.creationDate.isNotEmpty ? Text('Notatka z ${widget.note.creationDate}') : const Text('Nowa Notatka'),
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
          if (state is NoteSaved) {
            Navigator.pop(context, 'Notatka zapisana!');
          }
          if (state is NoteArchived) {
            Navigator.pop(context, 'Notatka zarchiwizowana!');
          }
        },
        builder: (context, state) {
          if (state is NoteInitial) {
            return Form(
              key: _noteFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Tytuł Notatki', 
                      style: TextStyle(
                        fontSize: 18.0, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 48.0,
                      right: 48.0,
                      bottom: 16.0,
                    ),
                    child: TextFormField(
                      readOnly: widget.note.state == 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nazwa notatki nie może być pusta!';
                        }
                        return null;
                      },
                      controller: _titleController,
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Treść Notatki', 
                      style: TextStyle(
                        fontSize: 18.0, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 48.0,
                      right: 48.0,
                      bottom: 16.0,
                    ),
                    child: TextFormField(
                      readOnly: widget.note.state == 2,
                      validator: (value) {
                        if (value!.length > 1000) {
                          return 'Notatka nie może być dłuższa niż 1000 znaków!';
                        }
                        return null;
                      },
                      controller: _contentController,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                    ),
                  ),
                  widget.note.state == 1 ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _saveNote, 
                        child: const Text('Zapisz'),
                      ),
                      ElevatedButton(
                        onPressed: _archiveNote, 
                        child: const Text('Zarchiwizuj'),
                      ),
                    ],
                  ) : ElevatedButton(
                    onPressed: _saveNote, 
                    child: const Text('Zapisz'),
                  ),
                ],
              ),
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