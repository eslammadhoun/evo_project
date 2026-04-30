import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/media_type_helper.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/services/notifications_service.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/dots_indecator.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_event.dart';
import 'package:evo_project/features/home/Domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/bloc/states/dashboard_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/home_state.dart';
import 'package:evo_project/features/home/presentation/bloc/states/related_products_state.dart';
import 'package:evo_project/features/notifications/Data/models/notification_model.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_event.dart';
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
      await NotificationsService.showNotification(
        title: 'Welcome back!',
        body: 'Enjoy the shopping expireince',
      );
      if (mounted) {
        context.read<NotificationsBloc>().add(
          InsertNotificationEvent(
            notificationEntity: NotificationEntity(
              notificationId: '0',
              title: 'Welcome back!',
              body: 'Enjoy the shopping expireince',
              notificationType: NotificationType.success,
              dateTime: DateTime.now(),
            ),
          ),
        );
        context.read<CartBloc>().add(GetCartProductsEvent());
        context.read<CartBloc>().add(GetCartDiscountEvent());
        context.read<HomeBloc>().add(GetDashboardEvent());
        context.read<HomeBloc>().add(
          GetRelatedProductsEvent(productId: '99790'),
        );
      }
    });
  }

  @override
  void dispose() {
    pageIndex.dispose();
    super.dispose();
  }

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
                  buildWhen: (prev, curr) =>
                      prev.dashboardState != curr.dashboardState,
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

                            SliverToBoxAdapter(
                              child: _featuredProducts(context: context),
                            ),
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
          PageView.builder(
            itemCount: listOfBanners.length,
            onPageChanged: (i) => pageIndex.value = i,
            itemBuilder: (context, index) {
              return _bannerWidget(
                context: context,
                banner: listOfBanners[index],
              );
            },
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
    return InkWell(
      onTap: () => context.pushNamed(
        RouteNames.productsPage,
        extra: {'category_id': banner.categoryId, 'title': banner.categoryId},
      ),
      child: Container(
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(
            top: BorderSide(color: Color(0xffDBE9F5), width: 4),
          ),
        ),
        child:
            (banner.type == 'full_tall_banner' ||
                banner.type == 'tall_banner' ||
                banner.type == 'tall_video')
            ? mediaWidget(banner.images.first.image)
            : Text('Eslam'),
      ),
    );
  }

  // Featured Products Section
  Widget _featuredProducts({required BuildContext context}) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.relatedProductsState != current.relatedProductsState,
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
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured products',
                      style: context.textStyles.headlineMedium,
                    ),
                    GestureDetector(
                      onTap: () => context.pushNamed(
                        RouteNames.productsPage,
                        extra: {
                          'page_title': 'Featured products',
                          'category_id': '1',
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
                        child: SizedBox(
                          width: 180,
                          child: RepaintBoundary(
                            child: ProductCard(
                              product: state
                                  .relatedProductsState
                                  .relatedProducts![index],
                            ),
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
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        }
      },
    );
  }
}
