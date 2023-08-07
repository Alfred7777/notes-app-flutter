import 'package:flutter/material.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'package:notes_app/resources/app_strings.dart';

class AppTextStyles {
  static const TextStyle kNoteCardTitleStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.kPrimaryColor,
  );
  static const TextStyle kNoteCardContentStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w300,
    fontSize: 10.5,
    color: AppColors.kLightPrimaryColor,
  );

  static const TextStyle kNoteViewTitleStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.kPrimaryColor,
  );
  static const TextStyle kNoteViewTitleHintStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    color: AppColors.kLightPrimaryColor,
  );
  static const TextStyle kNoteViewContentStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: AppColors.kPrimaryColor,
  );
  static const TextStyle kNoteViewContentHintStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w300,
    fontSize: 16,
    color: AppColors.kLightPrimaryColor,
  );
  static const TextStyle kNoteViewDateStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.kPrimaryColor,
  );
  static const TextStyle kNoteViewButtonTextStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.kMainBackgroundColor,
  );

  static const TextStyle kSearchBarTextStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.kLightPrimaryColor,
  );
  static TextStyle kSearchBarHintStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w300,
    fontSize: 12,
    color: AppColors.kLightPrimaryColor.withAlpha(180),
  );

  static const TextStyle kTabBarLabelStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );
}
