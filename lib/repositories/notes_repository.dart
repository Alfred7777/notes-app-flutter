import 'package:equatable/equatable.dart';

class NotesRepository {
  Future<List<Note>> getNotes() async {
    return [];
  }

  Future<void> createNote(String title, String content) async {

  }

  Future<void> editNote(int noteID, String newTitle, String newContent) async {

  }

  Future<Note> getNoteDetails() async {
    return const Note(id: 1, title: 'Notatka 1', content: 'Treść notatki.', creationDate: '25.01.2023', state: 1);
  }

  Future<void> archiveNote(int noteID) async {

  }
}

class Note extends Equatable {
  final int id;
  final String title;
  final String content;
  final String creationDate;
  final int state;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.creationDate,
    required this.state,
  });

  @override
  List<Object> get props => [id, title, content, creationDate, state];
}