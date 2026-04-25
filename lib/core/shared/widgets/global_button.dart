import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double height;
  final double? width;
  final bool? isFilled;
  final Widget? child;

  const GlobalButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.height,
    this.width,
    this.isFilled,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isFilled != null
              ? Color(0xffDBE9F5).withAlpha(39)
              : context.colors.primary,
          border: isFilled != null
              ? Border.all(color: context.colors.secondary, width: 1)
              : null,
        ),
        child: Center(
          child:
              child ??
              Text(
                text,
                style: TextStyle(
                  fontFamily: AppTypography.seconderyFont,
                  fontWeight: AppTypography.bold,
                  fontSize: 14,
                  color: isFilled != null
                      ? context.colors.primary
                      : context.colors.tertiary,
                ),
              ),
        ),
      ),
    );
  }
}
