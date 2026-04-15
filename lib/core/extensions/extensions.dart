import 'package:flutter/material.dart';

extension Extensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
}
