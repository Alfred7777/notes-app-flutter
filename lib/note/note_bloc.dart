import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import 'package:notes_app/repositories/note_repository.dart';
import 'package:notes_app/models/note.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository notesRepository;
  final Note note;

  NoteBloc({
    required this.notesRepository,
    required this.note,
  }) : super(NoteInitial(note: note)) {
    on<SaveNote>((event, emit) async {
      try {
        if (event.noteID > 0) {
          await notesRepository.editNote(
            event.noteID,
            event.noteTitle,
            event.noteContent,
          );
        } else {
          await notesRepository.createNote(
            event.noteTitle,
            event.noteContent,
          );
        }

        emit(
          NoteSaved(),
        );
      } catch (exception) {
        emit(
          const NoteError(
            error: 'Zapisanie notatki nie powiodło się!',
          ),
        );
      }
    });

    on<ArchiveNote>((event, emit) async {
      try {
        await notesRepository.archiveNote(
          event.noteID,
        );

        emit(
          NoteArchived(),
        );
      } catch (exception) {
        emit(
          const NoteError(
            error: 'Archiwizacja notatki nie powiodła się!',
          ),
        );
      }
    });
  }
}
