import 'dart:io';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/custom_navbar.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    double safeBottom = bottomPadding;
    if (safeBottom > 24) safeBottom = 20;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset('lib/assets/icons/menu.svg'),
              ),
            );
          },
        ),
        title: Text(
          navigationShell.currentIndex == 1
              ? 'Search'
              : navigationShell.currentIndex == 2
              ? 'Order'
              : navigationShell.currentIndex == 3
              ? 'Wishlist'
              : 'My Profile',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.colors.primary,
                  ),
                  child: Center(
                    child: BlocSelector<CartBloc, CartState, int>(
                      selector: (state) => state.cartProducts.length,
                      builder: (BuildContext context, cartProducts) => Text(
                        cartProducts.toString(),
                        style: context.textStyles.headlineLarge!.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => context.go(RoutePaths.cart),
                  child: SvgPicture.asset('lib/assets/icons/cart2.svg'),
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: navigationShell,
      drawer: AppDrawer(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          24,
          4,
          24,
          Platform.isIOS ? 0 : safeBottom,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF0F2A3C), const Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: CustomNavBar(
            selectedIndex: navigationShell.currentIndex,
            onTap: (index) {
              navigationShell.goBranch(index);
            },
          ),
        ),
      ),
    );
  }
}
