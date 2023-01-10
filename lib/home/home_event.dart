import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchNotes extends HomeEvent {
  final String textFilter;
  final String dateFilter;
  final int stateFilter;

  const FetchNotes({
    required this.textFilter,
    required this.dateFilter,
    required this.stateFilter,
  });

  @override
  List<Object> get props => [textFilter, dateFilter, stateFilter];
}

class ArchiveNote extends HomeEvent {
  final int noteID;

  const ArchiveNote({
    required this.noteID,
  });

  @override
  List<Object> get props => [noteID];
}

class ChangeFilters extends HomeEvent {
  final String textFilter;
  final String dateFilter;
  final int stateFilter;

  const ChangeFilters({
    required this.textFilter,
    required this.dateFilter,
    required this.stateFilter,
  });

  @override
  List<Object> get props => [textFilter, dateFilter, stateFilter];
}
