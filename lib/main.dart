import 'dart:async';
import 'package:evo_project/core/constants/providers.dart';
import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/env_config.dart';
import 'package:evo_project/core/router/app_router.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/services/auth_event_service.dart';
import 'package:evo_project/core/services/notifications_service.dart';
import 'package:evo_project/core/theme/app_theme.dart';
import 'package:evo_project/features/auth/domain/repositories/auth_reposotory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:evo_project/core/errors/failures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  await EnvConfig.init(fileName: ".env.prod");
  await initDI();
  unawaited(
    sl<AuthRepository>().refreshToken().catchError((e) {
      debugPrint("Background token refresh failed: $e");
      throw Left(ServerFailure("Refresh failed")) as Either<Failure, void>;
    }),
  );
  await NotificationsService().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<AuthEvent>? _authStream;
  @override
  void initState() {
    super.initState();
    // Listen for global auth events (like session expiration)
    _authStream = AuthEventService().authEvents.listen((event) {
      if (event == AuthEvent.unauthenticated) {
        AppRouter.router.goNamed(RouteNames.signin, extra: {'has_back': false});
      }
    });
  }

  @override
  void dispose() {
    _authStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: listOfProviders,
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        title: 'Nectar EVO',
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
