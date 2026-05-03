import 'package:flutter/material.dart';

class FloatingSnack extends StatefulWidget {
  final String message;

  const FloatingSnack({super.key, required this.message});

  @override
  State<FloatingSnack> createState() => _FloatingSnackState();
}

class _FloatingSnackState extends State<FloatingSnack>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    slide = Tween(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 120, // 👈 تتحكم فيه زي ما بدك
      left: 16,
      right: 16,
      child: SlideTransition(
        position: slide,
        child: Material(
          elevation: 10,
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
