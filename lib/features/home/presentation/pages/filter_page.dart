import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/theme/app_theme.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double minPrice = 0;
  double maxPrice = 3000;
  final List<String> listOfSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  int _selectedSizeIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
        child: GlobalButton(
          text: 'APPLY FILTERS',
          onTap: () {},
          height: 50.h(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.back,
              midWidget: MidWidget.text,
              lastWidget: LastWidget.nothing,
              text: 'Filter',
            ),
            const SizedBox(height: 28),
            Expanded(
              child: SingleChildScrollView(
                padding: Spacing.appPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (index) => _buttonItem(
                          context: context,
                          title: index == 0
                              ? 'SALE'
                              : index == 1
                              ? 'TOP'
                              : 'NEW',
                          isSelected: index == 0 ? true : false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    _priceIndecatorWidget(
                      context: context,
                      onChanged: (values) => setState(() {
                        minPrice = values.start;
                        maxPrice = values.end;
                      }),
                    ),
                    const SizedBox(height: 48),

                    Text('Size', style: context.textStyles.headlineSmall),
                    const SizedBox(height: 20),

                    // Sizes row
                    Row(
                      children: List.generate(
                        listOfSizes.length,
                        (index) => _sizeButton(
                          context: context,
                          size: listOfSizes[index],
                          index: index,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // build button item
  Widget _buttonItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: isSelected
              ? null
              : BoxBorder.all(color: Color(0xffDBE9F5), width: 1),
          color: isSelected
              ? context.colors.primary
              : Color(0xffDBE9F5).withAlpha(37),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: AppTypography.seconderyFont,
                fontWeight: AppTypography.bold,
                fontSize: 12,
                color: isSelected ? Colors.white : context.colors.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Price Indecator Widget
  Widget _priceIndecatorWidget({
    required BuildContext context,
    required void Function(RangeValues values)? onChanged,
  }) {
    final double min = 0;
    final double max = 3000;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        const double thumbSize = 24;
        const double horizontalPadding = 16;
        const double labelWidth = 50;

        double getPosition(double value) {
          final usableWidth = width - (horizontalPadding * 2);
          final percent = (value - min) / (max - min);

          return horizontalPadding + (percent * usableWidth) - (thumbSize / 2);
        }

        double safePosition(double value) {
          final pos = getPosition(value);
          return pos.clamp(0, width - labelWidth);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price', style: context.textStyles.headlineSmall),
            const SizedBox(height: 20),

            Stack(
              clipBehavior: Clip.none,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    rangeThumbShape: const SquareThumbShape(size: 24),
                    trackHeight: 4,
                  ),
                  child: RangeSlider(
                    values: RangeValues(minPrice, maxPrice),
                    min: min,
                    max: max,
                    onChanged: (values) {
                      onChanged?.call(values);
                    },
                    activeColor: context.colors.primary,
                    inactiveColor: const Color(0xffDBE9F5),
                  ),
                ),

                Positioned(
                  left: safePosition(minPrice),
                  bottom: -28,
                  child: SizedBox(
                    width: labelWidth,
                    child: Center(
                      child: Text(
                        '\$${minPrice.toInt()}',
                        style: context.textStyles.bodyMedium,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: safePosition(maxPrice),
                  bottom: -28,
                  child: SizedBox(
                    width: labelWidth,
                    child: Center(
                      child: Text(
                        '\$${maxPrice.toInt()}',
                        style: context.textStyles.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _sizeButton({
    required BuildContext context,
    required String size,
    required int index,
  }) {
    final isSelected = _selectedSizeIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () => setState(() => _selectedSizeIndex = index),
        child: AnimatedContainer(
          width: 40,
          height: 40,
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: BoxBorder.all(
              width: 1,
              color: isSelected
                  ? const Color(0xff1a1a2e)
                  : const Color(0xffDBE9F5),
            ),
            color: isSelected
                ? const Color(0xff1a1a2e)
                : const Color(0xffFAFCFE),
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
