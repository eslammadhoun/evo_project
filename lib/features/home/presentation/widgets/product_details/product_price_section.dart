import 'package:evo_project/core/constants/app_assets.dart';
import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/currency_symbols.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductPriceSection extends StatelessWidget {
  final Product product;
  final ValueNotifier<int> productQuantity;

  const ProductPriceSection({
    super.key,
    required this.product,
    required this.productQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('price'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.name ?? '',
                  style: context.textStyles.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(AppAssets.star, width: 16),
                  const SizedBox(width: 5),
                  Text(
                    (product.reviews ?? 0).toDouble().toString(),
                    style: context.textStyles.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            width: context.screenSize.width - 20,
            height: 55,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: Border(
                left: BorderSide(color: AppColors.border, width: 1),
                top: BorderSide(color: AppColors.border, width: 1),
                right: BorderSide.none,
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (product.discountPercentage ?? 0.0) != 0.0
                    ? Row(
                        children: [
                          Text(
                            '${CurrencySymbols.format.format((product.price ?? 0.0) * (product.discountPercentage ?? 1.0))}   ',
                            style: (context.textStyles.bodyMedium ?? const TextStyle()).copyWith(
                              color: context.colors.secondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            CurrencySymbols.format.format(product.price ?? 0.0),
                            style: context.textStyles.headlineMedium,
                          ),
                        ],
                      )
                    : Text(
                        CurrencySymbols.format.format(product.price ?? 0.0),
                        style: context.textStyles.headlineMedium,
                      ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => productQuantity.value != 1
                          ? productQuantity.value -= 1
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          AppAssets.minus,
                          width: 14.w(context),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40.w(context),
                      child: Center(
                        child: ValueListenableBuilder<int>(
                          valueListenable: productQuantity,
                          builder: (context, quantity, child) => Text(
                            quantity.toString(),
                            style: context.textStyles.bodySmall,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          productQuantity.value = productQuantity.value + 1,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset(AppAssets.plus),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
