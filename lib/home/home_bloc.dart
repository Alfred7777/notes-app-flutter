import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/repositories/notes_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NotesRepository notesRepository;

  HomeBloc({
    required this.notesRepository,
  }) : super(HomeUninitialized()) {
    on<FetchNotes>((event, emit) async {
      emit(HomeLoading());
      try {
        var noteList = await notesRepository.getNotes();

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

    on<CreateNote>((event, emit) async {
      emit(HomeLoading());
      try {
        await notesRepository.createNote(
          event.noteTitle,
          event.noteContent,
        );
        var noteList = await notesRepository.getNotes();

        emit(
          HomeReady(
            noteList: noteList,
          ),
        );
      } catch (exception) {
        emit(
          const HomeError(
            error: 'Utworzenie notatki nie powiodło się!',
          ),
        );
      }
    });

    on<EditNote>((event, emit) async {
      emit(HomeLoading());
      try {
        await notesRepository.editNote(
          event.noteID,
          event.noteTitle,
          event.noteContent,
        );
        var noteList = await notesRepository.getNotes();

        emit(
          HomeReady(
            noteList: noteList,
          ),
        );
      } catch (exception) {
        emit(
          const HomeError(
            error: 'Edycja notatki nie powiodła się!',
          ),
        );
      }
    });

    on<ArchiveNote>((event, emit) async {
      emit(HomeLoading());
      try {
        await notesRepository.archiveNote(
          event.noteID,
        );
        var noteList = await notesRepository.getNotes();

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