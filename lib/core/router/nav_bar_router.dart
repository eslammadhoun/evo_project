import 'package:evo_project/core/router/route_paths.dart';
import 'package:go_router/go_router.dart';
import 'package:evo_project/features/cart/Presentation/pages/cart_page.dart';
import 'package:evo_project/features/home/presentation/pages/navbar_pages/home_page.dart';
import 'package:evo_project/features/home/presentation/pages/main_page.dart';
import 'package:evo_project/features/home/presentation/pages/navbar_pages/profile_page.dart';
import 'package:evo_project/features/home/presentation/pages/navbar_pages/search_page.dart';
import 'package:evo_project/features/wishlist/presentation/pages/wishlist_page.dart';

final RouteBase bottomNavbarRouter = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainPage(navigationShell: navigationShell);
  },
  branches: [
    // Home Page
    StatefulShellBranch(
      routes: [
        GoRoute(path: RoutePaths.home, builder: (context, state) => HomePage()),
      ],
    ),

    // Search Page
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RoutePaths.search,
          builder: (context, state) => const SearchPage(),
        ),
      ],
    ),

    // Cart Page
    StatefulShellBranch(
      routes: [
        GoRoute(path: RoutePaths.cart, builder: (context, state) => CartPage()),
      ],
    ),

    // Wish list Page
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RoutePaths.wishList,
          builder: (context, state) => WishlistPage(),
        ),
      ],
    ),

    // Profile Page
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
);
