import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/router/nav_bar_router.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/succes_page.dart';
import 'package:evo_project/features/auth/presentation/pages/forget_password.dart';
import 'package:evo_project/features/auth/presentation/pages/new_password.dart';
import 'package:evo_project/features/auth/presentation/pages/signin_page.dart';
import 'package:evo_project/features/auth/presentation/pages/signup_page.dart';
import 'package:evo_project/features/cart/Presentation/pages/checkout_page.dart';
import 'package:evo_project/features/home/Domain/usecases/get_category.dart';
import 'package:evo_project/features/home/Domain/usecases/get_dashboard.dart';
import 'package:evo_project/features/home/Domain/usecases/get_product.dart';
import 'package:evo_project/features/home/Domain/usecases/get_related_products.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/home_event.dart';
import 'package:evo_project/features/home/presentation/pages/filter_page.dart';
import 'package:evo_project/features/home/presentation/pages/product_description_page.dart';
import 'package:evo_project/features/home/presentation/pages/product_details_page.dart';
import 'package:evo_project/features/home/presentation/pages/products_page.dart';
import 'package:evo_project/features/notifications/presentation/pages/notifications_page.dart';
import 'package:evo_project/features/onboarding/presentation/pages/onboarding.dart';
import 'package:evo_project/features/onboarding/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: sl<GlobalKey<NavigatorState>>(),
    initialLocation: RoutePaths.splash,
    routes: [
      // Splash Page
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // OnBoarding Page
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        builder: (context, state) => const Onboarding(),
      ),

      // SignIn Page
      GoRoute(
        path: RoutePaths.signin,
        name: RouteNames.signin,
        builder: (context, state) {
          final Map<String, dynamic> extraData =
              state.extra as Map<String, dynamic>;
          return SigninPage(hasBack: extraData['has_back']);
        },
      ),

      // SignUp Page
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) => SignupPage(),
      ),

      // Forget Password Page
      GoRoute(
        path: RoutePaths.forgetPassword,
        name: RouteNames.forgetPassword,
        builder: (context, state) => ForgetPassword(),
      ),

      // New Password Page
      GoRoute(
        path: RoutePaths.newPassword,
        name: RouteNames.newPassword,
        builder: (context, state) => NewPasswordPage(),
      ),

      // Success Page
      GoRoute(
        path: RoutePaths.succesPage,
        name: RouteNames.succesPage,
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return SuccesPage(
            title: data['title'],
            subTitle: data['subTitle'],
            iconPath: data['iconPath'],
            buttonText: data['buttonText'],
            destination: data['destination'],
          );
        },
      ),

      bottomNavbarRouter,

      // Products Page
      GoRoute(
        path: RoutePaths.productsPage,
        name: RouteNames.productsPage,
        builder: (context, state) {
          final Map<String, dynamic> data = state.extra as Map<String, dynamic>;
          return ProductsPage(
            pageTitle: data['page_title'],
            categoryId: data['category_id'],
          );
        },
      ),

      // Product Details Page
      GoRoute(
        path: RoutePaths.productDetailsPage,
        name: RouteNames.productDetailsPage,
        builder: (context, state) {
          final String productId = state.extra as String;
          return BlocProvider<HomeBloc>(
            create: (_) =>
                HomeBloc(
                    getProductsUsecase: sl<GetCategoryUsecase>(),
                    getProductUsecase: sl<GetProductUsecase>(),
                    getRelatedProductsUsecase: sl<GetRelatedProducts>(),
                    getDashboardUsecase: sl<GetDashboardUsecase>(),
                  )
                  ..add(GetProductEvent(productId: productId))
                  ..add(GetRelatedProductsEvent(productId: productId)),
            child: const ProductDetailsPage(),
          );
        },
      ),

      // Product Descriotion page
      GoRoute(
        path: RoutePaths.productDescriptionPage,
        name: RouteNames.productDescriptionPage,
        builder: (context, state) {
          final Map<String, dynamic> extraData =
              state.extra as Map<String, dynamic>;
          return ProductDescriptionPage(
            productName: extraData['product_name'],
            productDescription: extraData['product_description'],
          );
        },
      ),

      // Filter Page
      GoRoute(
        path: RoutePaths.filterPage,
        name: RouteNames.filterPage,
        builder: (context, state) => FilterPage(),
      ),

      // Checkout Page
      GoRoute(
        path: RoutePaths.checkoutPage,
        name: RouteNames.checkoutPage,
        builder: (context, state) => CheckoutPage(),
      ),

      // Notifications Page
      GoRoute(
        path: RoutePaths.notificationsPage,
        name: RouteNames.notificationsPage,
        builder: (context, state) => NotificationsPage(),
      ),
    ],
  );
}
