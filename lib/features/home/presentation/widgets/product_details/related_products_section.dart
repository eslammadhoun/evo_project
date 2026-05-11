import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/loading_indicator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RelatedProductsSection extends StatelessWidget {
  final String productId;
  const RelatedProductsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      buildWhen: (previous, current) =>
          previous.getRelatedProductsState != current.getRelatedProductsState ||
          previous.relatedProducts != current.relatedProducts,
      builder: (BuildContext context, state) {
        if (state.getRelatedProductsState == GetRelatedProductsStates.loading) {
          return const Center(
            child: AppLoadingIndicator(size: 60, strokeWidth: 8),
          );
        } else if (state.getRelatedProductsState == GetRelatedProductsStates.failure) {
          return Center(
            child: Text(
              state.getRelatedProductsErrorMessage ?? 'Failed to load related products',
            ),
          );
        } else if (state.getRelatedProductsState == GetRelatedProductsStates.success) {
          if (state.relatedProducts.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most Related Products',
                      style: context.textStyles.headlineMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.pushNamed(
                        RouteNames.productsPage,
                        extra: const {
                          'page_title': 'Most Related',
                          'category_id': '1', // Default or specific category
                        },
                      ),
                      child: Row(
                        children: [
                          Text(
                            'view  all',
                            style: context.textStyles.bodyMedium!.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                      state.relatedProducts.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: SizedBox(
                          width: context.screenSize.width * 0.4,
                          child: ProductCard(
                            product: state.relatedProducts[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
