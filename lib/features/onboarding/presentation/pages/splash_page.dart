import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppPreferences appPreferences = sl<AppPreferences>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final String userName = appPreferences.getUserName();
      final String userEmail = appPreferences.getUserEmail();
      final String? userToken = appPreferences.getToken();
      final bool isAuthenticated = appPreferences.isAuthenticated();
      final bool isOnboardingCompleted = appPreferences.isOnboardingCompleted();
      AppLogger.debug(
        isAuthenticated
            ? '----------------------------User Is Authenticated----------------------------\n'
                  'User Name: $userName\nUser Email: $userEmail\nUser Token $userToken'
            : '----------------------------User Is Not Authenticated----------------------------',
      );
      if (!mounted) return;
      isAuthenticated
          ? context.go(RoutePaths.home)
          : isOnboardingCompleted
          ? context.go(RoutePaths.signin, extra: {'has_back': false})
          : context.go(RoutePaths.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 140),
            SvgPicture.asset('lib/assets/icons/app_logo.svg'),
            const SizedBox(height: 20),
            Text(
              'kastelli',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: AppTypography.medium,
                letterSpacing: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
