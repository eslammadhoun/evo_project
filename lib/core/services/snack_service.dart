import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/shared/widgets/floating_snack.dart';
import 'package:flutter/material.dart';

class SnackService {
  static OverlayEntry? _overlayEntry;

  static void show(String message) {
    final navigator = sl<GlobalKey<NavigatorState>>().currentState;

    if (navigator == null) return;

    final overlay = navigator.overlay;

    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => FloatingSnack(message: message),
    );

    overlay!.insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      hide();
    });
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
