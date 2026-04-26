import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductCard extends StatelessWidget {
  final Product? product;
  final double cardHeight;

  const ProductCard({super.key, required this.cardHeight, this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.productDetailsPage,
          extra: product!.productId,
        );
      },
      child: Container(
        width: context.screenSize.width * 0.36,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(5),
              child: Container(
                height: cardHeight,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: product != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  product!.image ?? product!.images![0].url!,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                    child: AppLoadingIndicator(
                                      size: 40,
                                      strokeWidth: 4,
                                    ),
                                  ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'lib/assets/images/image.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => AppLogger.info('added to fav'),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: BoxBorder.all(
                              width: 2,
                              color: const Color(0xffDBE9F5),
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.favorite_outline,
                            color: context.colors.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              product != null ? product!.name! : 'Long summer dress',
              style: context.textStyles.bodySmall,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              product != null ? '\$ ${product!.price}' : '\$245.9',
              style: context.textStyles.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
