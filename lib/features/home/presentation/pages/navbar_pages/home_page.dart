import 'package:evo_project/core/constants/app_assets.dart';
import 'package:evo_project/core/services/snack_service.dart';
import 'package:evo_project/core/theme/app_colors.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/media_type_helper.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/services/notifications_service.dart';
import 'package:evo_project/core/shared/widgets/dots_indicator.dart';
import 'package:evo_project/core/shared/widgets/loading_indicator.dart';
import 'package:evo_project/core/shared/widgets/product_card.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_event.dart';
import 'package:evo_project/features/home/domain/entities/dashboard_entity.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_event.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_state.dart';
import 'package:evo_project/features/notifications/data/models/notification_model.dart';
import 'package:evo_project/features/notifications/domain/entities/notification.dart';
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
  static bool _hasShownWelcomeNotification = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_hasShownWelcomeNotification) {
        _hasShownWelcomeNotification = true;
        await NotificationsService.showNotification(
          title: 'Welcome back!',
          body: 'Enjoy the shopping experience',
        );
      }
      if (mounted) {
        context.read<NotificationsBloc>().add(
          InsertNotificationEvent(
            notificationEntity: NotificationEntity(
              notificationId: '0',
              title: 'Welcome back!',
              body: 'Enjoy the shopping experience',
              notificationType: NotificationType.success,
              dateTime: DateTime.now(),
            ),
          ),
        );
        context.read<DashboardBloc>().add(GetDashboardEvent());
        context.read<CategoryBloc>().add(
          const GetCategoryProductsEvent(categoryId: '1'),
        );
        context.read<CartBloc>().add(GetCartProductsEvent());
        context.read<CartBloc>().add(GetCartDiscountEvent());
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
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              BlocConsumer<DashboardBloc, DashboardState>(
                listener: (context, state) {
                  if (state.getDashboardState == GetDashboardStates.failure) {
                    SnackService.show(state.getDashboardErrorMessage!);
                  }
                },
                builder: (context, state) {
                  if (state.getDashboardState == GetDashboardStates.initial ||
                      state.getDashboardState == GetDashboardStates.loading) {
                    return const Expanded(
                      child: Center(
                        child: AppLoadingIndicator(size: 60, strokeWidth: 8),
                      ),
                    );
                  } else if (state.getDashboardState ==
                      GetDashboardStates.failure) {
                    return const SizedBox.shrink();
                  } else {
                    return Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            child: SizedBox(
                              height: 300.h(context),
                              child: _topHeaderBanners(
                                context: context,
                                listOfBanners: state.topBanners!,
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => SizedBox(
                                height: 200.h(context),
                                child: _bannerWidget(
                                  context: context,
                                  banner: state.footerBanners![index],
                                ),
                              ),
                              childCount: state.footerBanners!.length,
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
            top: 20,
            right: 20,
            child: SvgPicture.asset(AppAssets.appLogo),
          ),
        ],
      ),
    );
  }

  Widget _topHeaderBanners({
    required BuildContext context,
    required List<BannerEntity> listOfBanners,
  }) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
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
            child: listOfBanners.length > 1
                ? DotsIndicator(
                    valueListenable: pageIndex,
                    dotsCount: listOfBanners.length,
                  )
                : const SizedBox(),
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
        extra: {'category_id': banner.categoryId, 'page_title': 'Products'},
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 4)),
        ),
        child:
            (banner.type == 'full_tall_banner' ||
                banner.type == 'tall_banner' ||
                banner.type == 'tall_video')
            ? mediaWidget(banner.images.first.image)
            : const Center(child: Text('Promo Banner')),
      ),
    );
  }

  Widget _featuredProducts({required BuildContext context}) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (BuildContext context, state) {
        if (state.getCategoryState == GetCategoryStates.loading) {
          return const Center(
            child: AppLoadingIndicator(size: 60, strokeWidth: 8),
          );
        } else if (state.getCategoryState == GetCategoryStates.failure) {
          return Center(
            child: Text(
              state.getCategoryErrorMessage ??
                  'Failed to load featured products',
            ),
          );
        } else if (state.getCategoryState == GetCategoryStates.success) {
          if (state.categoryProducts.isEmpty) return const SizedBox.shrink();
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
                            'view all',
                            style: context.textStyles.bodyMedium!.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 255.h(context),
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.categoryProducts.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: SizedBox(
                        width: 180,
                        child: ProductCard(
                          product: state.categoryProducts[index],
                        ),
                      ),
                    );
                  },
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
