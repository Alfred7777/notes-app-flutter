import 'package:equatable/equatable.dart';

class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class SaveNote extends NoteEvent {
  final int noteID;
  final String noteTitle;
  final String noteContent;

  const SaveNote({
    required this.noteID,
    required this.noteTitle,
    required this.noteContent,
  });

  @override
  List<Object> get props => [noteID, noteTitle, noteContent];
}
