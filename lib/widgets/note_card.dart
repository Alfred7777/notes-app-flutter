import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'package:notes_app/resources/app_paddings.dart';
import 'package:notes_app/resources/app_text_styles.dart';

class NoteCard extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Note note;
  final Function(Note) onTap;
  final Function(int) onLongPress;
  
  const NoteCard({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

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
      child: Padding(
        padding: const EdgeInsets.all(
          AppPaddings.kNoteCardContentPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppPaddings.kNoteCardTitlePadding,
              ),
              child: Text(
                note.title, 
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
                note.content, 
                maxLines: 12,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.kNoteContentStyle,
              ),
            ),
          ],
        ),
      )
    );
  }
}