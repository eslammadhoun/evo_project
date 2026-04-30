import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/bloc/states/category_products_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/home_state.dart';
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
      context.read<HomeBloc>().add(
        GetCatecoryProductsEvent(categoryId: widget.categoryId ?? '0'),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isFetching) return;

    final state = context.read<HomeBloc>().state.categoryProductsState;
    final position = _scrollController.position;

    if (!state.hasMore) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      setState(() {
        _isFetching = true;
      });

      context.read<HomeBloc>().add(
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
            HeaderWidget(
              firstWidget: FirstWidget.back,
              midWidget: MidWidget.text,
              lastWidget: LastWidget.cart,
              text: widget.pageTitle ?? 'Products',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: Spacing.appPadding,
                child: Column(
                  children: [
                    /// 🔹 Top bar
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

                    BlocListener<HomeBloc, HomeState>(
                      listenWhen: (prev, curr) =>
                          prev.categoryProductsState.page !=
                              curr.categoryProductsState.page ||
                          prev.categoryProductsState.getCategoryState !=
                              curr.categoryProductsState.getCategoryState,
                      listener: (context, state) {
                        final categoryState = state.categoryProductsState;

                        if (categoryState.getCategoryState ==
                                GetCategoryStates.success ||
                            categoryState.getCategoryState ==
                                GetCategoryStates.failure) {
                          if (mounted) {
                            setState(() {
                              _isFetching = false;
                            });
                          }
                        }
                        if (categoryState.getCategoryState ==
                            GetCategoryStates.failure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state
                                    .categoryProductsState
                                    .getCategoryErrorMessage!,
                              ),
                            ),
                          );
                        }
                      },
                      child:
                          BlocSelector<
                            HomeBloc,
                            HomeState,
                            CategoryProductsState
                          >(
                            selector: (state) => state.categoryProductsState,
                            builder: (context, categoryState) {
                              if (categoryState.getCategoryState ==
                                  GetCategoryStates.loading) {
                                return const Expanded(
                                  child: Center(
                                    child: AppLoadingIndicator(
                                      size: 65,
                                      strokeWidth: 8,
                                    ),
                                  ),
                                );
                              }
                              if (categoryState.getCategoryState ==
                                  GetCategoryStates.success) {
                                final list = categoryState.categoryProducts!;
                                return Expanded(
                                  child: CustomScrollView(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    slivers: [
                                      /// 🔹 Grid
                                      SliverGrid(
                                        delegate: SliverChildBuilderDelegate((
                                          context,
                                          index,
                                        ) {
                                          return ProductCard(
                                            key: ValueKey(
                                              list[index].productId,
                                            ),
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
                                            padding: EdgeInsets.symmetric(
                                              vertical: 20,
                                            ),
                                            child: Center(
                                              child: AppLoadingIndicator(
                                                size: 45,
                                                strokeWidth: 5,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }

                              return const SizedBox();
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

  /// 🔹 Filter Widget
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
