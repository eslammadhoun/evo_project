import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/cart/presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/category/category_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/profile/profile_bloc.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:evo_project/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> listOfProviders = [
  BlocProvider<DashboardBloc>(create: (context) => sl<DashboardBloc>()),
  BlocProvider<CategoryBloc>(create: (context) => sl<CategoryBloc>()),
  BlocProvider<ProfileBloc>(create: (context) => sl<ProfileBloc>()),
  BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
  BlocProvider<CartBloc>(create: (context) => sl<CartBloc>()),
  BlocProvider<WishlistBloc>(create: (context) => sl<WishlistBloc>()),
  BlocProvider<NotificationsBloc>(create: (context) => sl<NotificationsBloc>()),
];
