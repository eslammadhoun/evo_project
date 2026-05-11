import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsTabBar extends StatelessWidget {
  final bool isCollapsed;
  final int selectedTab;
  final Function(int) onTabSelected;

  const ProductDetailsTabBar({
    super.key,
    required this.isCollapsed,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      height: isCollapsed ? 44.0 : 0.0,
      width: context.screenSize.width,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: 44,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TabItem(
                  label: 'PRICE',
                  index: 0,
                  isActive: selectedTab == 0,
                  onTap: () => onTabSelected(0),
                ),
                _TabItem(
                  label: 'DESCRIPTION',
                  index: 1,
                  isActive: selectedTab == 1,
                  onTap: () => onTabSelected(1),
                ),
                _TabItem(
                  label: 'REVIEWS',
                  index: 2,
                  isActive: selectedTab == 2,
                  onTap: () => onTabSelected(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int index;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.index,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 44,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.tabActive : Colors.transparent,
              width: isActive ? 4 : 1,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.08,
            color: isActive ? AppColors.tabActive : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
