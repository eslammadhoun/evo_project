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

class SquareThumbShape extends RangeSliderThumbShape {
  final double size;

  const SquareThumbShape({this.size = 20});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(size, size);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = true,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final canvas = context.canvas;

    final paint = Paint()..color = sliderTheme.thumbColor ?? Colors.blue;

    final rect = Rect.fromCenter(center: center, width: size, height: size);

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(6)), paint);
  }
}
