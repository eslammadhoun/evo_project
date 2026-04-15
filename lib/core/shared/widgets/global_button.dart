import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const GlobalButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: context.colors.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppTypography.seconderyFont,
              fontWeight: AppTypography.bold,
              fontSize: 14,
              color: context.colors.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
