import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    // Colors
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: AppColors.mainColor,
      secondary: AppColors.textColor,
      tertiary: AppColors.whiteColor,
    ),

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: TextStyles.headingsH1,
      headlineMedium: TextStyles.headingsH3,
      headlineSmall: TextStyles.headingsH5,
      bodyMedium: TextStyles.textStyle16,
      bodySmall: TextStyles.textStyle14,
      labelMedium: TextStyles.textStyle14Medium,
    ),
  );
}
