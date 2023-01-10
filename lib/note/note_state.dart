import 'package:equatable/equatable.dart';
import 'package:notes_app/repositories/note_repository.dart';

class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteLoading extends NoteState {}

class NoteInitial extends NoteState {
  final Note note;

  const NoteInitial({
    required this.note,
  });

  @override
  List<Object> get props => [note];
}

class NoteSaved extends NoteState {}

class NoteError extends NoteState {
  final String error;

  const NoteError({required this.error});

  @override
  List<Object> get props => [error];
}
