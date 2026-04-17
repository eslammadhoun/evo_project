import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductsPage extends StatelessWidget {
  final String pageTitle;
  const ProductsPage({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.back,
              midWidget: MidWidget.text,
              lastWidget: LastWidget.cart,
              text: pageTitle,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: Spacing.appPadding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              String selected = 'best match';
                              return Dialog(
                                child: StatefulBuilder(
                                  builder: (context, setState) => _filterWidget(
                                    context: context,
                                    selected: selected,
                                    onChanged: (value) {
                                      setState(() {
                                        selected = value;
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'lib/assets/icons/filter_icon.svg',
                                width: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Filter',
                                style: context.textStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => AppLogger.info('Sorting by'),
                          child: Row(
                            children: [
                              Text(
                                'Sorting by',
                                style: context.textStyles.bodyMedium,
                              ),
                              const SizedBox(width: 7),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: context.colors.secondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: GridView.builder(
                        itemCount: 20,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) =>
                            ProductCard(cardHeight: 240),
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

  // Filter Widget
  Widget _filterWidget({
    required BuildContext context,
    required String selected,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _filterItem(
            context: context,
            filterType: 'Best match',
            selected: selected,
            onChanged: onChanged,
          ),
          _filterItem(
            context: context,
            filterType: 'Price: low to high',
            selected: selected,
            onChanged: onChanged,
          ),
          _filterItem(
            context: context,
            filterType: 'Price: high to low',
            selected: selected,
            onChanged: onChanged,
          ),
          _filterItem(
            context: context,
            filterType: 'Newest',
            selected: selected,
            onChanged: onChanged,
          ),
          _filterItem(
            context: context,
            filterType: 'Customer rating',
            selected: selected,
            onChanged: onChanged,
          ),
          _filterItem(
            context: context,
            filterType: 'Most popular',
            lastItem: true,
            selected: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // build filter type widget
  Widget _filterItem({
    required BuildContext context,
    required String filterType,
    required String selected,
    required Function(String) onChanged,
    bool lastItem = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: lastItem
            ? null
            : const Border(bottom: BorderSide(color: Color(0xffDBE9F5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(filterType, style: context.textStyles.bodySmall),
          Radio<String>(
            value: filterType,
            groupValue: selected,
            onChanged: (value) => onChanged(value!),
          ),
        ],
      ),
    );
  }
}
