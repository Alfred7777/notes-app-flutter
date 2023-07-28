import 'package:flutter/material.dart';
import 'package:notes_app/resources/app_colors.dart';
import 'package:notes_app/resources/app_strings.dart';

class AppTextStyles {
  static const TextStyle kNoteTitleStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w500,
    fontSize: 13,
    color: AppColors.kPrimaryColor,
  );
  static TextStyle kNoteContentStyle = TextStyle(
    fontFamily: AppStrings.kDefaultFontName,
    fontWeight: FontWeight.w300,
    fontSize: 10.5,
    color: AppColors.kPrimaryColor.withAlpha(180),
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
