import 'package:equatable/equatable.dart';
import 'package:notes_app/models/note.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class HomeLoading extends HomeState {}

class HomeReady extends HomeState {
  final List<Note> noteList;

  const HomeReady({
    required this.noteList,
  });

  @override
  List<Object> get props => [noteList];
}

class HomeError extends HomeState {
  final String error;

  const HomeError({required this.error});

  @override
  List<Object> get props => [error];
}
