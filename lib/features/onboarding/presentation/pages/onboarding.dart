import 'package:evo_project/core/constants/on_boarding_const.dart';
import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/di/service_locator.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int selectedIndex = 0;
  final AppPreferences appPreferences = sl<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Spacing.appPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.screenSize.height * 0.10),
            Text(
              OnBoardingConst.onBoardingTexts[selectedIndex],
              style: context.textStyles.headlineLarge,
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: context.screenSize.width * .60,
              child: Text(
                'Labore sunt culpa excepteur culpa occaecat ex nisi mollit.',
                style: context.textStyles.bodyMedium,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: List.generate(
                OnBoardingConst.onBoardingTexts.length,
                (index) => Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedIndex == index
                            ? context.colors.primary
                            : context.colors.secondary.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: GlobalButton(
                onTap: () => selectedIndex != 2
                    ? setState(() {
                        selectedIndex++;
                      })
                    : {
                        context.pushNamed(
                          RouteNames.signin,
                          extra: {'has_back': true},
                        ),
                        appPreferences.setOnboardingCompleted(true),
                      },
                text: selectedIndex != 2 ? 'NEXT' : 'GET STARTED',
                height: 50.h(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
