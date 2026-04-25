import 'package:evo_project/core/constants/providers.dart';
import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/env_config.dart';
import 'package:evo_project/core/router/app_router.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/services/auth_signals.dart';
import 'package:evo_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EnvConfig.init(fileName: ".env.prod");
  await initDI();
  AuthSignals.unauthenticated.stream.listen((_) {
    // redirect to login
    AppRouter.router.go(RoutePaths.signin);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: listOfProviders,
      child: MaterialApp.router(
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
