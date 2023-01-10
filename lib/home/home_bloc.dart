import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/repositories/note_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NoteRepository notesRepository;

  HomeBloc({
    required this.notesRepository,
  }) : super(HomeUninitialized()) {
    on<FetchNotes>((event, emit) async {
      emit(HomeLoading());
      try {
        var noteList = await notesRepository.getNotes(
          event.textFilter,
          event.dateFilter,
          event.stateFilter,
        );

        emit(
          HomeReady(
            noteList: noteList,
          ),
        );
      } catch (exception) {
        emit(
          const HomeError(
            error: 'Wczytanie listy notatek nie powiodło się!',
          ),
        );
      }
    });

    on<ArchiveNote>((event, emit) async {
      try {
        await notesRepository.archiveNote(
          event.noteID,
        );
      } catch (exception) {
        emit(
          const HomeError(
            error: 'Archiwizacja notatki nie powiodła się!',
          ),
        );
      }
    });

    on<ChangeFilters>((event, emit) async {
      emit(HomeLoading());
      try {
        var noteList = await notesRepository.getNotes(
          event.textFilter,
          event.dateFilter,
          event.stateFilter,
        );

        emit(
          HomeReady(
            noteList: noteList,
          ),
        );
      } catch (exception) {
        emit(
          const HomeError(
            error: 'Archiwizacja notatki nie powiodła się!',
          ),
        );
      }
    });
  }
}