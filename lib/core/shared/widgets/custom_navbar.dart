import 'package:evo_project/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kBottomNavigationBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final bool isSelected = index == selectedIndex;
          return _buildItem(
            context: context,
            index: index,
            isSelected: isSelected,
          );
        }),
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required int index,
    required bool isSelected,
  }) {
    final icons = ['home', 'search', 'cart', 'heart', 'profile'];

    return GestureDetector(
      onTap: () => onTap(index),
      child: SizedBox(
        width: (context.screenSize.width - 90) / 5,
        child: AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSelected ? 1.0 : 0.6,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  SvgPicture.asset('lib/assets/icons/active BG.svg'),

                Positioned(
                  top: isSelected ? 20 : null,
                  child: SvgPicture.asset(
                    'lib/assets/icons/${icons[index]}.svg',
                    // ignore: deprecated_member_use
                    color: isSelected ? context.colors.primary : null,
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
