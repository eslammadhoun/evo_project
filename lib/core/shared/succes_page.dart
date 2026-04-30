import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SuccesPage extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subTitle;
  final String buttonText;
  final String destination;

  const SuccesPage({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconPath,
    required this.destination,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Spacing.appPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: BoxBorder.all(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset('lib/assets/icons/$iconPath.svg'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(title, style: context.textStyles.headlineLarge),
                  const SizedBox(height: 14),
                  Text(subTitle, style: context.textStyles.bodyMedium),
                ],
              ),
              GlobalButton(
                text: buttonText,
                onTap: () {
                  if (destination == 'signIn') {
                    context.goNamed(
                      RouteNames.signin,
                      extra: {'has_back': true},
                    );
                  } else if (destination == 'home') {
                    context.goNamed(RouteNames.home);
                  }
                },
                height: 50.h(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
