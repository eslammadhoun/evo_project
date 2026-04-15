import 'package:evo_project/core/router/route_names.dart';
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
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.goNamed(RouteNames.onboarding);
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
