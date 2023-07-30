import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'package:notes_app/resources/app_paddings.dart';
import 'package:notes_app/resources/app_text_styles.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function(Note) editNote;
  final Function(int) archiveNote;

  const NoteCard({
    Key? key,
    required this.note,
    required this.editNote,
    required this.archiveNote,
  }) : super(key: key);

  @override
  NoteCardState createState() => NoteCardState();
}

class NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppPaddings.kNoteCardPadding,
        ),
      ),
      margin: EdgeInsets.zero,
      color: AppColors.kWidgetBackgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppPaddings.kNoteCardPadding,
        ),
        onTap: () => widget.editNote(widget.note),
        onLongPress: () => widget.archiveNote(widget.note.id),
        child: Padding(
          padding: const EdgeInsets.all(
            AppPaddings.kNoteCardContentPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: AppPaddings.kNoteCardTitlePadding,
                ),
                child: Text(
                  widget.note.title, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.kNoteTitleStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppPaddings.kNoteCardTitlePadding,
                ),
                child: Text(
                  widget.note.content, 
                  maxLines: 12,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.kNoteContentStyle,
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}