import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'package:notes_app/repositories/note_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NoteRepository notesRepository;

  HomeBloc({
    required this.notesRepository,
  }) : super(HomeUninitialized()) {
    var dateFormatter = DateFormat("yyyy-MM-dd");

    on<FetchNotes>((event, emit) async {
      emit(HomeLoading());
      try {
        var noteList = await notesRepository.getNotes(
          '',
          dateFormatter.format(DateTime.now()),
          -1,
        );

        emit(
          HomeReady(
            noteList: noteList,
            nameFilter: '',
            dateFilter: dateFormatter.format(DateTime.now()),
            stateFilter: -1,
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
        var noteList = await notesRepository.getNotes(
          '',
          dateFormatter.format(DateTime.now()),
          -1,
        );

        emit(
          HomeReady(
            noteList: noteList,
            nameFilter: '',
            dateFilter: dateFormatter.format(DateTime.now()),
            stateFilter: -1,
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
        var noteList = await notesRepository.getNotes(
          '',
          dateFormatter.format(DateTime.now()),
          -1,
        );

        emit(
          HomeReady(
            noteList: noteList,
            nameFilter: '',
            dateFilter: dateFormatter.format(DateTime.now()),
            stateFilter: -1,
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
        var noteList = await notesRepository.getNotes(
          '',
          dateFormatter.format(DateTime.now()),
          -1,
        );

        emit(
          HomeReady(
            noteList: noteList,
            nameFilter: '',
            dateFilter: dateFormatter.format(DateTime.now()),
            stateFilter: -1,
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

    on<ChangeFilters>((event, emit) async {
      emit(HomeLoading());
      try {
        var noteList = await notesRepository.getNotes(
          event.nameFilter,
          event.dateFilter,
          event.stateFilter,
        );

        emit(
          HomeReady(
            noteList: noteList,
            nameFilter: event.nameFilter,
            dateFilter: event.dateFilter,
            stateFilter: event.stateFilter,
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