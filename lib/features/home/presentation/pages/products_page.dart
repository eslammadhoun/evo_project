import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/services/snack_service.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indicator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_state.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_event.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatefulWidget {
  final String? pageTitle;
  final String? categoryId;

  const ProductsPage({
    super.key,
    required this.pageTitle,
    required this.categoryId,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late ScrollController _scrollController;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryBloc>().add(
        GetCategoryProductsEvent(categoryId: widget.categoryId ?? '0'),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients || _isFetching) return;

    final state = context.read<CategoryBloc>().state;
    final position = _scrollController.position;

    if (!state.hasMore) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      setState(() {
        _isFetching = true;
      });

      context.read<CategoryBloc>().add(
        LoadMoreCategoryProductsEvent(categoryId: widget.categoryId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BlocSelector<CartBloc, CartState, int>(
              selector: (state) => state.cartProducts.length,
              builder: (BuildContext context, cartProducts) => HeaderWidget(
                firstWidget: FirstWidget.back,
                midWidget: MidWidget.text,
                lastWidget: LastWidget.cart,
                text: widget.pageTitle ?? 'Products',
                cartProducts: cartProducts,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: Spacing.appPadding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => context.pushNamed(RouteNames.filterPage),
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
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              String selected = 'Best match';
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
                      child: BlocConsumer<CategoryBloc, CategoryState>(
                        listener: (context, state) {
                          if (state.getCategoryState ==
                                  GetCategoryStates.success ||
                              state.getCategoryState ==
                                  GetCategoryStates.failure) {
                            if (mounted) {
                              setState(() {
                                _isFetching = false;
                              });
                            }
                          }
                          if (state.getCategoryState ==
                              GetCategoryStates.failure) {
                            SnackService.show(state.getCategoryErrorMessage!);
                          }
                        },
                        builder: (context, state) {
                          if (state.getCategoryState ==
                                  GetCategoryStates.loading &&
                              state.categoryProducts.isEmpty) {
                            return const Center(
                              child: AppLoadingIndicator(
                                size: 65,
                                strokeWidth: 8,
                              ),
                            );
                          }

                          if (state.categoryProducts.isEmpty &&
                              state.getCategoryState ==
                                  GetCategoryStates.success) {
                            return const Center(
                              child: Text('No products found'),
                            );
                          }

                          final list = state.categoryProducts;
                          return CustomScrollView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            slivers: [
                              SliverGrid(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  return ProductCard(
                                    key: ValueKey(list[index].productId),
                                    product: list[index],
                                  );
                                }, childCount: list.length),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 0.58,
                                      mainAxisExtent: 280.h(context),
                                    ),
                              ),
                              if (_isFetching)
                                const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
                                      child: AppLoadingIndicator(
                                        size: 45,
                                        strokeWidth: 5,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
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
