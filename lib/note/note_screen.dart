import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/repositories/note_repository.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/resources/app_paddings.dart';
import 'package:notes_app/resources/app_text_styles.dart';
import 'package:notes_app/resources/app_strings.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'note_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  
  const NoteScreen({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteScreen> createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {
  final NoteRepository noteRepository = NoteRepository();
  late NoteBloc _noteBloc;

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  final _noteFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _noteBloc = NoteBloc(
      notesRepository: noteRepository,
      note: widget.note,
    );

    _titleController = TextEditingController(
      text: widget.note.title,
    );
    _contentController = TextEditingController(
      text: widget.note.content,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _noteBloc.close();
    super.dispose();
  }

  void _saveNote() {
    if (_noteFormKey.currentState!.validate()) {
      _noteBloc.add(
        SaveNote(
          noteID: widget.note.id,
          noteTitle: _titleController.text, 
          noteContent: _contentController.text,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.kPrimaryColor,
          backgroundColor: AppColors.kMainBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '${widget.note.creationDate.isEmpty ? '' : '${widget.note.creationDate} |'} ${_contentController.text.length} characters',
            style: AppTextStyles.kNoteViewDateStyle,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveNote,
            ),
          ],
        ),
        backgroundColor: AppColors.kMainBackgroundColor,
        body: BlocConsumer(
          bloc: _noteBloc,
          listener: (context, state) {
            if (state is NoteError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: AppColors.kSecondAccentColor,
                ),
              );
            }
            if (state is NoteSaved) {
              Navigator.pop(context, AppStrings.kCreateNoteConfirmation);
            }
            if (state is NoteArchived) {
              Navigator.pop(context, AppStrings.kArchiveNoteConfirmation);
            }
          },
          builder: (context, state) {
            if (state is NoteInitial) {
              return Form(
                key: _noteFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppPaddings.kNoteViewVerticalPadding,
                        left: AppPaddings.kNoteViewHorizontalPadding,
                        right: AppPaddings.kNoteViewHorizontalPadding,
                      ),
                      child: TextFormField(
                        readOnly: widget.note.isArchived,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.kNoteEmptyTitleError;
                          }
                          return null;
                        },
                        controller: _titleController,
                        style: AppTextStyles.kNoteViewTitleStyle,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintStyle: AppTextStyles.kNoteViewTitleHintStyle,
                          hintText: AppStrings.kNoteTitleHint,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPaddings.kNoteViewHorizontalPadding,
                        ),
                        child: TextFormField(
                          readOnly: widget.note.isArchived,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.kNoteEmptyContentError;
                            }
                            if (value.length > 1000) {
                              return AppStrings.kNoteLengthError;
                            }
                            return null;
                          },
                          onChanged: (value) => setState(() {}),
                          controller: _contentController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: null,
                          style: AppTextStyles.kNoteViewContentStyle,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintStyle: AppTextStyles.kNoteViewContentHintStyle,
                            hintText: AppStrings.kNoteContentHint,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.kMainAccentColor,
              ),
            );
          }
        ),
      ),
    );
  }
}