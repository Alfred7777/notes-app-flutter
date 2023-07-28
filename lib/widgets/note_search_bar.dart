import 'package:flutter/material.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'package:notes_app/resources/app_paddings.dart';
import 'package:notes_app/resources/app_text_styles.dart';

class NoteSearchBar extends StatelessWidget {
  final TextEditingController queryTextController;

  const NoteSearchBar({
    Key? key,
    required this.queryTextController,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppPaddings.kNoteCardPadding,
        horizontal: AppPaddings.kNoteCardPadding * 2,
      ),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.kLightPrimaryColor.withAlpha(40),
          borderRadius: BorderRadius.circular(
            AppPaddings.kNoteCardPadding,
          ),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: AppPaddings.kSearchBarIconPadding * 1.5,
                right: AppPaddings.kSearchBarIconPadding,
              ),
              child: Icon(
                Icons.search,
                color: AppColors.kLightPrimaryColor,
                size: 14,
              ),
            ),
            Flexible(
              child: TextField(
                controller: queryTextController,
                style: AppTextStyles.kSearchBarTextStyle,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Search notes',
                  hintStyle: AppTextStyles.kSearchBarHintStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}