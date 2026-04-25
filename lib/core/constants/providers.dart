import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> listOfProviders = [
  BlocProvider<HomeBloc>(create: (context) => sl<HomeBloc>()),
  BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
];
