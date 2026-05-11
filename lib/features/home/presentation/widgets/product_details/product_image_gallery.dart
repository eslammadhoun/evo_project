import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/shared/widgets/dots_indicator.dart';
import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/shared/widgets/loading_indicator.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';
import 'package:evo_project/features/wishlist/domain/entities/wishlist_item.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductImageGallery extends StatelessWidget {
  final Product product;
  final ValueNotifier<int> productImageIndex;
  final bool isCollapsed;
  final int selectedSizeIndex;
  final Function(int) onSizeSelected;
  final Widget Function(BuildContext, String, int) sizeButtonBuilder;

  const ProductImageGallery({
    super.key,
    required this.product,
    required this.productImageIndex,
    required this.isCollapsed,
    required this.selectedSizeIndex,
    required this.onSizeSelected,
    required this.sizeButtonBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistItems = context.select<WishlistBloc, List<WishlistItem>>(
      (bloc) => bloc.state.wishlist,
    );

    final isFav = wishlistItems.any(
      (item) => item.productId == product.productId,
    );

    return Container(
      width: double.infinity,
      height: context.screenSize.height * 0.63,
      decoration: const BoxDecoration(
        color: AppColors.galleryBackground,
        border: Border(top: BorderSide(width: 1, color: AppColors.border)),
      ),
      child: Stack(
        children: [
          // Page View
          PageView(
            onPageChanged: (i) => productImageIndex.value = i,
            children: List.generate(
              product.images?.length ?? 0,
              (index) => CachedNetworkImage(
                imageUrl: product.images?[index].url ?? '',
                progressIndicatorBuilder: (context, url, progress) =>
                    const Center(
                      child: AppLoadingIndicator(size: 60, strokeWidth: 8),
                    ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Sizes overlay — visible when collapsed (scroll up)
          Positioned(
            left: 20,
            bottom: 20,
            child: AnimatedSlide(
              offset: isCollapsed ? Offset.zero : const Offset(-1.5, 0),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: isCollapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 320),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.options?.firstOrNull?.variants?.length ?? 0,
                    (index) => GestureDetector(
                      onTap: () => onSizeSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: sizeButtonBuilder(
                          context,
                          product
                                  .options
                                  ?.firstOrNull
                                  ?.variants?[index]
                                  .label ??
                              '',
                          index,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Dots indicator
          Positioned(
            right: 0,
            left: 0,
            bottom: 31,
            child: DotsIndicator(
              valueListenable: productImageIndex,
              dotsCount: product.images?.length ?? 0,
            ),
          ),

          // Heart button — always visible
          Positioned(
            bottom: 24,
            right: 20,
            child: InkWell(
              onTap: () {
                context.read<WishlistBloc>().add(
                  ToggleWishlistEvent(
                    WishlistItem(
                      productId: product.productId ?? '',
                      name: product.name ?? '',
                      image: product.images?.firstOrNull?.url ?? '',
                      price: product.price ?? 0.0,
                      rate: product.reviews?.toDouble() ?? 0,
                    ),
                  ),
                );
              },
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? AppColors.error : context.colors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
