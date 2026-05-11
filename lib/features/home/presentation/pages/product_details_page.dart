import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/services/snack_service.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indicator.dart';
import 'package:evo_project/features/cart/domain/entities/cart_item.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_event.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_state.dart';
import 'package:evo_project/features/home/domain/entities/product.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/product_details/product_details_state.dart';
import 'package:evo_project/features/home/presentation/widgets/product_details/product_description_section.dart';
import 'package:evo_project/features/home/presentation/widgets/product_details/product_details_tab_bar.dart';
import 'package:evo_project/features/home/presentation/widgets/product_details/product_image_gallery.dart';
import 'package:evo_project/features/home/presentation/widgets/product_details/product_price_section.dart';
import 'package:evo_project/features/home/presentation/widgets/product_details/related_products_section.dart';
import 'package:evo_project/features/home/presentation/widgets/product_details/size_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> productImageIndex = ValueNotifier(0);
  final ValueNotifier<int> productQuantity = ValueNotifier(1);
  final ScrollController _scrollController = ScrollController();

  bool _isCollapsed = false;
  int _selectedSizeIndex = -1;
  int _selectedTab = 0;
  final double _collapseThreshold = 10.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldCollapse = offset > _collapseThreshold;
    if (shouldCollapse != _isCollapsed) {
      setState(() => _isCollapsed = shouldCollapse);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    productImageIndex.dispose();
    productQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          buildWhen: (previous, current) =>
              previous.getProductDetailsState != current.getProductDetailsState,
          builder: (BuildContext context, state) {
            if (state.getProductDetailsState == GetProductDetails.loading ||
                state.getProductDetailsState == GetProductDetails.initial) {
              return const Center(
                child: AppLoadingIndicator(size: 60, strokeWidth: 8),
              );
            }

            if (state.getProductDetailsState == GetProductDetails.failure) {
              return _ErrorView(message: state.getProductDetailsErrorMessage!);
            }

            final product = state.product!;
            return _ProductDetailsView(
              product: product,
              scrollController: _scrollController,
              isCollapsed: _isCollapsed,
              selectedSizeIndex: _selectedSizeIndex,
              selectedTab: _selectedTab,
              productImageIndex: productImageIndex,
              productQuantity: productQuantity,
              onSizeSelected: (index) =>
                  setState(() => _selectedSizeIndex = index),
              onTabSelected: (index) => setState(() => _selectedTab = index),
              onScrollNotification: (notification) {
                final offset = notification.metrics.pixels;
                final shouldCollapse = offset < _collapseThreshold;
                if (shouldCollapse != _isCollapsed) {
                  setState(() => _isCollapsed = shouldCollapse);
                }
                return false;
              },
            );
          },
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<CartBloc, CartState, int>(
          selector: (state) => state.cartProducts.length,
          builder: (context, cartCount) => HeaderWidget(
            firstWidget: FirstWidget.back,
            midWidget: MidWidget.nothing,
            lastWidget: LastWidget.cart,
            cartProducts: cartCount,
          ),
        ),
        Expanded(child: Center(child: Text(message))),
      ],
    );
  }
}

class _ProductDetailsView extends StatelessWidget {
  final Product product;
  final ScrollController scrollController;
  final bool isCollapsed;
  final int selectedSizeIndex;
  final int selectedTab;
  final ValueNotifier<int> productImageIndex;
  final ValueNotifier<int> productQuantity;
  final Function(int) onSizeSelected;
  final Function(int) onTabSelected;
  final bool Function(ScrollNotification) onScrollNotification;

  const _ProductDetailsView({
    required this.product,
    required this.scrollController,
    required this.isCollapsed,
    required this.selectedSizeIndex,
    required this.selectedTab,
    required this.productImageIndex,
    required this.productQuantity,
    required this.onSizeSelected,
    required this.onTabSelected,
    required this.onScrollNotification,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.addProductToCartState != current.addProductToCartState,
      listener: (context, state) {
        if (state.addProductToCartState == AddProductToCartState.failure) {
          SnackService.show(
            'failed to add product to cart: ${state.addProductToCartErrorMessage}',
          );
        } else if (state.addProductToCartState ==
            AddProductToCartState.success) {
          SnackService.show('Product Added To Cart');
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              BlocSelector<CartBloc, CartState, int>(
                selector: (state) => state.cartProducts.length,
                builder: (context, cartCount) => HeaderWidget(
                  firstWidget: FirstWidget.back,
                  midWidget: MidWidget.nothing,
                  lastWidget: LastWidget.cart,
                  cartProducts: cartCount,
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: onScrollNotification,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      ProductImageGallery(
                        product: product,
                        productImageIndex: productImageIndex,
                        isCollapsed: isCollapsed,
                        selectedSizeIndex: selectedSizeIndex,
                        onSizeSelected: onSizeSelected,
                        sizeButtonBuilder: (context, size, index) =>
                            SizeSelectorItem(
                              size: size,
                              isSelected: selectedSizeIndex == index,
                              onTap: () => onSizeSelected(index),
                            ),
                      ),
                      ProductDetailsTabBar(
                        isCollapsed: isCollapsed,
                        selectedTab: selectedTab,
                        onTabSelected: onTabSelected,
                      ),
                      _AnimatedDetailsContent(
                        isCollapsed: isCollapsed,
                        selectedTab: selectedTab,
                        product: product,
                        productQuantity: productQuantity,
                        selectedSizeIndex: selectedSizeIndex,
                        onSizeSelected: onSizeSelected,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) =>
                previous.addProductToCartState !=
                    current.addProductToCartState ||
                previous.cartProducts != current.cartProducts,
            builder: (context, state) {
              final isProductInCart = state.cartProducts.any(
                (e) => e.productId == product.productId,
              );
              return _AddToCartButton(
                product: product,
                isProductInCart: isProductInCart,
                selectedSizeIndex: selectedSizeIndex,
                productQuantity: productQuantity,
                isLoading:
                    state.addProductToCartState ==
                    AddProductToCartState.loading,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedDetailsContent extends StatelessWidget {
  final bool isCollapsed;
  final int selectedTab;
  final Product product;
  final ValueNotifier<int> productQuantity;
  final int selectedSizeIndex;
  final Function(int) onSizeSelected;

  const _AnimatedDetailsContent({
    required this.isCollapsed,
    required this.selectedTab,
    required this.product,
    required this.productQuantity,
    required this.selectedSizeIndex,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 380),
      crossFadeState: isCollapsed
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstCurve: Curves.easeInOutCubic,
      secondCurve: Curves.easeInOutCubic,
      sizeCurve: Curves.easeInOutCubic,
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductPriceSection(
            product: product,
            productQuantity: productQuantity,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: Spacing.appPadding,
            child: Text('Size', style: context.textStyles.headlineSmall),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: Spacing.appPadding,
            child: Row(
              children: List.generate(
                product.options?.firstOrNull?.variants?.length ?? 0,
                (index) => SizeSelectorItem(
                  size:
                      product.options?.firstOrNull?.variants?[index].label ??
                      'S',
                  isSelected: selectedSizeIndex == index,
                  onTap: () => onSizeSelected(index),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ProductDescriptionSection(
            productName: product.name ?? '',
            productDescription:
                product
                    .options
                    ?.firstOrNull
                    ?.variants
                    ?.firstOrNull
                    ?.description ??
                '',
          ),
          const SizedBox(height: 20),
          RelatedProductsSection(productId: product.productId ?? ''),
        ],
      ),
      secondChild: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: selectedTab == 0
            ? ProductPriceSection(
                product: product,
                productQuantity: productQuantity,
              )
            : selectedTab == 1
            ? ProductDescriptionSection(
                productName: product.name ?? '',
                productDescription:
                    product
                        .options
                        ?.firstOrNull
                        ?.variants
                        ?.firstOrNull
                        ?.description ??
                    '',
              )
            : _ReviewsPlaceholder(),
      ),
    );
  }
}

class _ReviewsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Spacing.appPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Reviews', style: context.textStyles.headlineSmall),
          const SizedBox(height: 12),
          Text('No reviews yet.', style: context.textStyles.bodyMedium),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final Product product;
  final bool isProductInCart;
  final int selectedSizeIndex;
  final ValueNotifier<int> productQuantity;
  final bool isLoading;

  const _AddToCartButton({
    required this.product,
    required this.isProductInCart,
    required this.selectedSizeIndex,
    required this.productQuantity,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: SizedBox(
        width: context.screenSize.width - 40,
        child: GlobalButton(
          text: isProductInCart ? 'Remove From Cart' : '+ ADD TO CART',
          onTap: () {
            final cartBloc = context.read<CartBloc>();
            if (isProductInCart) {
              cartBloc.add(
                DeleteProductFromCartEvent(productId: product.productId ?? ''),
              );
              productQuantity.value = 1;
            } else if (selectedSizeIndex >= 0) {
              cartBloc.add(
                AddProductToCartEvent(
                  cartItem: CartItem(
                    productId: product.productId ?? '',
                    name: product.name ?? '',
                    price: product.price ?? 0.0,
                    quantity: productQuantity.value,
                    image: product.images?.firstOrNull?.url ?? '',
                    size:
                        product
                            .options
                            ?.firstOrNull
                            ?.variants?[selectedSizeIndex]
                            .label ??
                        '',
                  ),
                ),
              );
            } else {
              SnackService.show('You Must Choose Product Size');
            }
          },
          height: 50.h(context),
          child: isLoading
              ? const AppLoadingIndicator(size: 40, strokeWidth: 6)
              : null,
        ),
      ),
    );
  }
}
