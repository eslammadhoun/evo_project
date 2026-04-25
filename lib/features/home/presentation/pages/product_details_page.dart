import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/dots_indecator.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:evo_project/features/home/Domain/entities/product.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/states/home_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/product_details_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> productImageIndex = ValueNotifier(0);
  final ScrollController _scrollController = ScrollController();

  bool _isCollapsed = false;
  int _selectedSizeIndex = -1;
  int _quantity = 1;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, state) {
            if (state.productDetailsState.getProductDetailsState ==
                    GetProductDetails.loading ||
                state.productDetailsState.getProductDetailsState ==
                    GetProductDetails.initial) {
              return Center(
                child: AppLoadingIndicator(size: 60, strokeWidth: 8),
              );
            } else if (state.productDetailsState.getProductDetailsState ==
                GetProductDetails.failure) {
              return Center(
                child: Text(
                  state.productDetailsState.getProductDetailsErrorMessage!,
                ),
              );
            } else {
              return Stack(
                children: [
                  Column(
                    children: [
                      HeaderWidget(
                        firstWidget: FirstWidget.back,
                        midWidget: MidWidget.nothing,
                        lastWidget: LastWidget.cart,
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            final offset = notification.metrics.pixels;
                            final shouldCollapse = offset < _collapseThreshold;
                            if (shouldCollapse != _isCollapsed) {
                              setState(() => _isCollapsed = shouldCollapse);
                            }
                            return false;
                          },
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              _productImages(
                                context: context,
                                product: state.productDetailsState.product!,
                              ),
                              _collapsedDetailsBar(context: context),
                              _productDetailsExpanded(
                                context: context,
                                product: state.productDetailsState.product!,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: SizedBox(
                      width: context.screenSize.width - 40,
                      child: GlobalButton(
                        text: '+ ADD TO CART',
                        onTap: () => print('object'),
                        height: 50.h(context),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // ─── Image Section ───────────────────────────────────────────────────────────
  Widget _productImages({
    required BuildContext context,
    required Product product,
  }) {
    return Container(
      width: double.infinity,
      height: context.screenSize.height * 0.55,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 222, 227, 235),
        border: BoxBorder.fromLTRB(
          top: BorderSide(width: 1, color: const Color(0xffDBE9F5)),
        ),
      ),
      child: Stack(
        children: [
          // Page View
          PageView(
            onPageChanged: (i) => productImageIndex.value = i,
            children: List.generate(
              product.images!.length,
              (index) => CachedNetworkImage(
                imageUrl: product.images![index].url!,
                progressIndicatorBuilder: (context, url, progress) => Center(
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
              offset: _isCollapsed ? Offset.zero : const Offset(-1.5, 0),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeInOutCubic,
              child: AnimatedOpacity(
                opacity: _isCollapsed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 320),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    product.options!.first.variants!.length,
                    (index) => GestureDetector(
                      onTap: () => setState(() => _selectedSizeIndex = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: _sizeButton(
                          context: context,
                          size: product.options!.first.variants![index].label!,
                          index: index,
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
            child: DotsIndecator(
              valueListenable: productImageIndex,
              dotsCount: product.images!.length,
            ),
          ),

          // Heart button — always visible
          Positioned(
            bottom: 24,
            right: 20,
            child: InkWell(
              onTap: () => print('object'),
              child: SvgPicture.asset(
                'lib/assets/icons/heart.svg',
                color: context.colors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Collapsed Tab Bar (PRICE / DESCRIPTION) ─────────────────────────────────
  Widget _collapsedDetailsBar({required BuildContext context}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
      height: _isCollapsed ? 44.0 : 0.0,
      width: context.screenSize.width,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              bottom: BorderSide(color: const Color(0xffDBE9F5)),
            ),
          ),
          child: Padding(
            padding: Spacing.appPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _tabItem(label: 'PRICE', index: 0),
                _tabItem(label: 'DESCRIPTION', index: 1),
                _tabItem(label: 'REVIEWS', index: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabItem({required String label, required int index}) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 44,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xff1a1a2e) : Colors.white,
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
            color: isActive ? const Color(0xff1a1a2e) : const Color(0xff999999),
          ),
        ),
      ),
    );
  }

  // ─── Expanded Details (normal scroll state) ──────────────────────────────────
  Widget _productDetailsExpanded({
    required BuildContext context,
    required Product product,
  }) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 380),
      crossFadeState: _isCollapsed
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      firstCurve: Curves.easeInOutCubic,
      secondCurve: Curves.easeInOutCubic,
      sizeCurve: Curves.easeInOutCubic,

      // ── First: full layout (scroll down — default view)
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & Rating
          _priceTabContent(context: context, product: product),
          const SizedBox(height: 20),

          // Size label
          Padding(
            padding: Spacing.appPadding,
            child: Text('Size', style: context.textStyles.headlineSmall),
          ),
          const SizedBox(height: 10),

          // Sizes row
          Padding(
            padding: Spacing.appPadding,
            child: Row(
              children: List.generate(
                product.options!.first.variants!.length,
                (index) => _sizeButton(
                  context: context,
                  size: product.options!.first.variants![index].label!,
                  index: index,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Description
          _descriptionTabContent(
            context: context,
            productName: product.name!,
            productDescription: product.options![0].variants![0].description!,
          ),
          const SizedBox(height: 20),
          _mostRelatedProducts(context: context),
        ],
      ),

      // ── Second: collapsed tab content (scroll up)
      secondChild: _buildCollapsedTabContent(
        context: context,
        product: product,
      ),
    );
  }

  // ─── Tab Content when collapsed ───────────────────────────────────────────────
  Widget _buildCollapsedTabContent({
    required BuildContext context,
    required Product product,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      child: _selectedTab == 0
          ? _priceTabContent(context: context, product: product)
          : _selectedTab == 1
          ? _descriptionTabContent(
              context: context,
              productName: product.name!,
              productDescription: product.description!,
            )
          : _reviewsTabContent(context: context),
    );
  }

  // PRICE tab
  Widget _priceTabContent({
    required BuildContext context,
    required Product product,
  }) {
    return Column(
      key: const ValueKey('price'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: Spacing.appPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(product.name!, style: context.textStyles.headlineMedium),
              Row(
                children: [
                  SvgPicture.asset('lib/assets/icons/star.svg', width: 16),
                  const SizedBox(width: 5),
                  Text(
                    product.reviews!.toDouble().toString(),
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
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              border: BoxBorder.fromLTRB(
                left: const BorderSide(color: Color(0xffDBE9F5), width: 1),
                top: const BorderSide(color: Color(0xffDBE9F5), width: 1),
                right: BorderSide.none,
                bottom: const BorderSide(color: Color(0xffDBE9F5), width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                product.discountPercentage != 0.0
                    ? Row(
                        children: [
                          Text(
                            '\$${product.price! * product.discountPercentage!}   ',
                            style: context.textStyles.bodyMedium!.copyWith(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            '\$${product.price}',
                            style: context.textStyles.headlineMedium,
                          ),
                        ],
                      )
                    : Text(
                        '\$${product.price}',
                        style: context.textStyles.headlineMedium,
                      ),
                Row(
                  children: [
                    InkWell(
                      onTap: () => setState(
                        () => _quantity = (_quantity - 1).clamp(1, 99),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          width: 14.w(context),
                          'lib/assets/icons/minus.svg',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40.w(context),
                      child: Center(
                        child: Text(
                          '$_quantity',
                          style: context.textStyles.bodySmall,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setState(
                        () => _quantity = (_quantity + 1).clamp(1, 99),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset('lib/assets/icons/plus.svg'),
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

  // DESCRIPTION tab
  Widget _descriptionTabContent({
    required BuildContext context,
    required String productName,
    required String productDescription,
  }) {
    return Padding(
      key: const ValueKey('description'),
      padding: Spacing.appPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Description', style: context.textStyles.headlineSmall),
          const SizedBox(height: 12),
          Text(
            productDescription,
            style: context.textStyles.bodyMedium,
            maxLines: 5,
          ),
          InkWell(
            onTap: () => context.pushNamed(
              RouteNames.productDescriptionPage,
              extra: {
                'product_name': productName,
                'product_description': productDescription,
              },
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                'read more  >',
                style: context.textStyles.bodyMedium!.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // REVIEWS tab (placeholder)
  Widget _reviewsTabContent({required BuildContext context}) {
    return Padding(
      key: const ValueKey('reviews'),
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

  // ─── Size Button ─────────────────────────────────────────────────────────────
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

  // Most Related Products Section
  Widget _mostRelatedProducts({required BuildContext context}) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (BuildContext context, state) {
        if (state.relatedProductsState.getRelatedProductsState ==
            GetRelatedProductsStates.loading) {
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        } else if (state.relatedProductsState.getRelatedProductsState ==
            GetRelatedProductsStates.failure) {
          return Center(
            child: Text(
              state.relatedProductsState.getRelatedProductsErrorMessage!,
            ),
          );
        } else if (state.relatedProductsState.getRelatedProductsState ==
            GetRelatedProductsStates.success) {
          return Column(
            children: [
              Padding(
                padding: Spacing.appPadding,
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
                        extra: {'page_title': 'Most Related'},
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
                          Icon(Icons.arrow_forward_ios),
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
                      state.relatedProductsState.relatedProducts!.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: ProductCard(
                          cardHeight: 200,
                          product: state
                              .relatedProductsState
                              .relatedProducts![index],
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
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        }
      },
    );
  }
}
