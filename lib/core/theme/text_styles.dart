import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle headingsH1 = TextStyle(
    fontFamily: AppTypography.headingsFont,
    fontSize: 32,
    fontWeight: AppTypography.bold,
    color: AppColors.mainColor,
  );

  static TextStyle headingsH3 = TextStyle(
    fontFamily: AppTypography.headingsFont,
    fontWeight: AppTypography.medium,
    fontSize: 20,
    color: AppColors.mainColor,
  );

  static TextStyle headingsH5 = TextStyle(
    fontFamily: AppTypography.headingsFont,
    fontWeight: AppTypography.semiBold,
    fontSize: 14,
    color: AppColors.mainColor,
  );

  static TextStyle textStyle16 = TextStyle(
    fontFamily: AppTypography.seconderyFont,
    fontSize: 16,
    fontWeight: AppTypography.regular,
    color: AppColors.textColor,
  );

  static TextStyle textStyle14 = TextStyle(
    fontFamily: AppTypography.seconderyFont,
    fontSize: 14,
    fontWeight: AppTypography.regular,
    color: AppColors.textColor,
  );

  static TextStyle textStyle14Medium = TextStyle(
    fontFamily: AppTypography.seconderyFont,
    fontSize: 14,
    fontWeight: AppTypography.medium,
    color: AppColors.mainColor,
  );
}
