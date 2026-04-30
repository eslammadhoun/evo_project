import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/cache_manager.dart';
import 'package:evo_project/core/helpers/currency_symbols.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product? product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.select<WishlistBloc, List<WishlistItem>>(
      (bloc) => bloc.state.wishlist,
    );

    final isFav = product != null
        ? wishlist.any((item) => item.productId == product?.productId)
        : false;

    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.productDetailsPage,
          extra: product!.productId,
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 0.70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: product != null
                            ? CachedNetworkImage(
                                cacheManager: MyCacheManager(),
                                imageUrl:
                                    product!.image ?? product!.images![0].url!,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, progress) => const Center(
                                      child: AppLoadingIndicator(
                                        size: 35,
                                        strokeWidth: 3,
                                      ),
                                    ),
                                errorWidget: (_, _, _) =>
                                    const Icon(Icons.error),
                              )
                            : Image.asset(
                                'lib/assets/images/image.png',
                                fit: BoxFit.cover,
                              ),
                      ),

                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          onTap: () {
                            context.read<WishlistBloc>().add(
                              ToggleWishlistEvent(
                                WishlistItem(
                                  productId: product!.productId!,
                                  name: product!.name!,
                                  image: product!.images![0].url!,
                                  price: product!.price!,
                                  rate: product!.rating?.toDouble() ?? 0.0,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isFav
                                  ? Colors.red
                                  : context.colors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Flexible(
                child: Text(
                  product?.name ?? 'Product Name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.bodySmall,
                ),
              ),

              const SizedBox(height: 4),

              Flexible(
                child: Text(
                  product != null
                      ? CurrencySymbols.format.format(product!.price)
                      : '\$100',
                  style: context.textStyles.labelMedium,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
