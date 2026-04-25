import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/media_type_helper.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/dots_indecator.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:evo_project/features/home/Domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/bloc/states/dashboard_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/home_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> pageIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<HomeBloc>().add(GetDashboardEvent());
      // context.read<HomeBloc>().add(GetRelatedProductsEvent(productId: '99790'));
    });
  }

  /*
  
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                HeaderWidget(
                  firstWidget: FirstWidget.menu,
                  midWidget: MidWidget.nothing,
                  lastWidget: LastWidget.cart,
                ),
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state.dashboardState.getDashboardState ==
                        GetDashboardStates.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.dashboardState.getDashboardErrorMessage!,
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.dashboardState.getDashboardState ==
                        GetDashboardStates.initial) {
                      return Center(
                        child: AppLoadingIndicator(size: 60, strokeWidth: 8),
                      );
                    } else if (state.dashboardState.getDashboardState ==
                        GetDashboardStates.loading) {
                      return Center(
                        child: AppLoadingIndicator(size: 60, strokeWidth: 8),
                      );
                    } else if (state.dashboardState.getDashboardState ==
                        GetDashboardStates.failure) {
                      return SizedBox.shrink();
                    } else {
                      return Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              child: _topHeaderBanners(
                                context: context,
                                listOfBanners: state.dashboardState.topBanners!,
                              ),
                            ),
                            ...List.generate(
                              state.dashboardState.footerBanners!.length,
                              (index) => SliverFillRemaining(
                                child: _bannerWidget(
                                  context: context,
                                  banner: state
                                      .dashboardState
                                      .footerBanners![index],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(child: _listSection(context)),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            Positioned(
              top: kToolbarHeight + 20,
              right: 20,
              child: SvgPicture.asset('lib/assets/icons/app_logo.svg'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topHeaderBanners({
    required BuildContext context,
    required List<BannerEntity> listOfBanners,
  }) {
    return Container(
      width: double.infinity,
      color: Color(0xffECF3FA),
      child: Stack(
        children: [
          PageView(
            onPageChanged: (i) => pageIndex.value = i,
            children: List.generate(
              listOfBanners.length,
              (index) =>
                  _bannerWidget(context: context, banner: listOfBanners[index]),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              children: [
                listOfBanners.length > 1
                    ? DotsIndecator(
                        valueListenable: pageIndex,
                        dotsCount: listOfBanners.length,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerWidget({
    required BuildContext context,
    required BannerEntity banner,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(
          top: BorderSide(color: Color(0xffDBE9F5), width: 4),
        ),
      ),
      child: Stack(
        children: [
          (banner.type == 'tall_video' || banner.type == 'tall_banner')
              ? Positioned.fill(child: mediaWidget(banner.images.first.image))
              : SizedBox(),

          Positioned(
            bottom: 110,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.description,
                  style: context.textStyles.headlineLarge!,
                ),
                SizedBox(height: 30.h(context)),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  child: InkWell(
                    onTap: () => context.pushNamed(
                      RouteNames.productsPage,
                      extra: {'category_id': banner.categoryId},
                    ),
                    child: Text(
                      'SHOP NOW',
                      style: context.textStyles.bodyMedium!.copyWith(
                        fontSize: 12,
                        color: context.colors.primary,
                        fontWeight: AppTypography.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listSection(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 50),
        _featuredProducts(context: context),
      ],
    );
  }

  // Featured Products Section
  Widget _featuredProducts({required BuildContext context}) {
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
                      'Featured products',
                      style: context.textStyles.headlineMedium,
                    ),
                    GestureDetector(
                      onTap: () => print('Viewing All'),
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
