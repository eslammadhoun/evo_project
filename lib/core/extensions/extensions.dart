import 'package:flutter/material.dart';

extension Extensions on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
}

extension Responsive on num {
  double w(BuildContext context) =>
      this * MediaQuery.of(context).size.width / 375;

  double h(BuildContext context) =>
      this * MediaQuery.of(context).size.height / 812;
}
