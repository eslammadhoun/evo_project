import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class SizeSelectorItem extends StatelessWidget {
  final String size;
  final bool isSelected;
  final VoidCallback onTap;

  const SizeSelectorItem({
    super.key,
    required this.size,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          width: 40,
          height: 40,
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              width: 1,
              color: isSelected
                  ? AppColors.tabActive
                  : AppColors.border,
            ),
            color: isSelected
                ? AppColors.tabActive
                : AppColors.surfaceVariant,
          ),
          child: Center(
            child: Text(
              size,
              style: context.textStyles.bodySmall!.copyWith(
                color: isSelected ? Colors.white : context.colors.primary,
                fontWeight: AppTypography.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
