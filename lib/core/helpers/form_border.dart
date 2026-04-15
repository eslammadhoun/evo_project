import 'package:flutter/material.dart';

class TopBottomInputBorder extends InputBorder {
  final BorderSide borderSide;

  const TopBottomInputBorder({this.borderSide = const BorderSide()});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  TopBottomInputBorder copyWith({BorderSide? borderSide}) {
    return TopBottomInputBorder(borderSide: borderSide ?? this.borderSide);
  }

  @override
  bool get isOutline => false;

  @override
  ShapeBorder scale(double t) {
    return TopBottomInputBorder(borderSide: borderSide.scale(t));
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0,
    double gapPercentage = 0,
    TextDirection? textDirection,
  }) {
    final paint = borderSide.toPaint();

    // Top line
    canvas.drawLine(rect.topLeft, rect.topRight, paint);

    // Bottom line
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, paint);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }
}
