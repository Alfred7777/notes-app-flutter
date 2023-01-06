import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchNotes extends HomeEvent {}

class FetchNoteDetails extends HomeEvent {
  final int noteID;

  const FetchNoteDetails({
    required this.noteID,
  });

  @override
  List<Object> get props => [noteID];
}

class CreateNote extends HomeEvent {
  final String noteTitle;
  final String noteContent;

  const CreateNote({
    required this.noteTitle,
    required this.noteContent,
  });

  @override
  List<Object> get props => [noteTitle, noteContent];
}

class EditNote extends HomeEvent {
  final int noteID;
  final String noteTitle;
  final String noteContent;

  const EditNote({
    required this.noteID,
    required this.noteTitle,
    required this.noteContent,
  });

  @override
  List<Object> get props => [noteID, noteTitle, noteContent];
}

class ArchiveNote extends HomeEvent {
  final int noteID;

  const ArchiveNote({
    required this.noteID,
  });

  @override
  List<Object> get props => [noteID];
}