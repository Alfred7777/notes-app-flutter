import 'package:equatable/equatable.dart';
import 'package:notes_app/repositories/note_repository.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeUninitialized extends HomeState {}

class HomeLoading extends HomeState {}

class HomeReady extends HomeState {
  final List<Note> noteList;
  final String nameFilter;
  final String dateFilter;
  final int stateFilter;

  const HomeReady({
    required this.noteList,
    required this.nameFilter,
    required this.dateFilter,
    required this.stateFilter,
  });

  @override
  List<Object> get props => [noteList, nameFilter, dateFilter, stateFilter];
}

class HomeError extends HomeState {
  final String error;

  const HomeError({required this.error});

  @override
  List<Object> get props => [error];
}
