import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/currency_symbols.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) async {
      context.read<WishlistBloc>().add(GetWishlistEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.select<WishlistBloc, List<WishlistItem>>(
      (bloc) => bloc.state.wishlist,
    );

    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: BlocConsumer<WishlistBloc, WishlistState>(
          builder: (BuildContext context, state) {
            if (state.getWishlistState == GetWishlistState.loading ||
                state.getWishlistState == GetWishlistState.initial) {
              return Center(
                child: AppLoadingIndicator(size: 60, strokeWidth: 8),
              );
            }
            if (state.getWishlistState == GetWishlistState.success) {
              if (wishlist.isEmpty) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: GlobalButton(
                      text: 'SHOP NOW',
                      onTap: () =>
                          StatefulNavigationShell.of(context).goBranch(0),
                      height: 50.h(context),
                      isFilled: true,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    HeaderWidget(
                      firstWidget: FirstWidget.menu,
                      midWidget: MidWidget.text,
                      lastWidget: LastWidget.cart,
                      text: 'Wishlist',
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        itemBuilder: (context, index) => _wishItemWidget(
                          context: context,
                          wishlistItem: wishlist[index],
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemCount: wishlist.length,
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Center(
                child: Text(
                  'Error While Fetching Wishlist, Please Try Again Later, ${state.errorMessage!}',
                ),
              );
            }
          },
          listener: (BuildContext context, state) {
            if (state.getWishlistState == GetWishlistState.failure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
        ),
      ),
    );
  }

  // Wish item Widget
  Widget _wishItemWidget({
    required BuildContext context,
    required WishlistItem wishlistItem,
  }) {
    return InkWell(
      onTap: () => context.pushNamed(
        RouteNames.productDetailsPage,
        extra: wishlistItem.productId,
      ),
      child: SizedBox(
        width: context.screenSize.width - 20,
        height: 120.h(context),
        child: Row(
          children: [
            Container(
              width: 100.h(context),
              height: 120.w(context),
              decoration: BoxDecoration(
                color: Color(0xffF6F8FB),
                borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(5)),
                child: CachedNetworkImage(
                  imageUrl: wishlistItem.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(
                    child: SvgPicture.asset('lib/assets/icons/app_logo.svg'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: BoxBorder.symmetric(
                    horizontal: BorderSide(color: Color(0xffDBE9F5), width: 1),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.screenSize.width * 0.50,
                            child: Text(
                              wishlistItem.name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: context.textStyles.bodyMedium,
                            ),
                          ),

                          // ❤️ القلب
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: _iconButton(
                              icon: 'lib/assets/icons/heart-filled.svg',
                              color: const Color.fromARGB(255, 255, 106, 95),
                              onTap: () => context.read<WishlistBloc>().add(
                                ToggleWishlistEvent(wishlistItem),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        CurrencySymbols.format.format(wishlistItem.price),
                        style: context.textStyles.bodyMedium!.copyWith(
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/icons/star.svg',
                                  width: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  wishlistItem.rate.toString(),
                                  style: context.textStyles.bodyMedium,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: _iconButton(
                                icon: 'lib/assets/icons/plus.svg',
                                color: context.colors.primary,
                                onTap: () => AppLogger.info('Adding'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({
    required String icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 44, // 👈 Apple/Google recommended touch size
          height: 44,
          alignment: Alignment.center,
          child: SvgPicture.asset(icon, width: 20, height: 20, color: color),
        ),
      ),
    );
  }
}
