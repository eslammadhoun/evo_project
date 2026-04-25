import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/router/route_paths.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/theme/text_styles.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_event.dart';
import 'package:evo_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.menu,
              midWidget: MidWidget.text,
              lastWidget: LastWidget.cart,
              text: 'My Profile',
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [
                  _profileAcount(context: context),
                  const SizedBox(height: 30),
                  _profileWidget(
                    context: context,
                    title: 'My Orders',
                    iconName: 'orders_icon',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(2),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Payment method',
                    iconName: 'credit-card',
                    onTap: () =>
                        context.pushNamed(RouteNames.productDetailsPage),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Delivery address',
                    iconName: 'map-pin',
                    onTap: () =>
                        context.pushNamed(RouteNames.productDetailsPage),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Promocodes & gift cards',
                    iconName: 'gift',
                    onTap: () =>
                        context.pushNamed(RouteNames.productDetailsPage),
                  ),
                  _profileWidget(
                    context: context,
                    title: 'Sign out',
                    iconName: 'log-out',
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: StatefulBuilder(
                            builder: (context, setState) =>
                                _signOutPubup(context: context),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Widget
  Widget _profileAcount({required BuildContext context}) {
    return Padding(
      padding: Spacing.appPadding,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffECF3FA),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Callie Mosley',
                        style: context.textStyles.headlineSmall,
                      ),
                    ),
                    InkWell(
                      onTap: () => AppLogger.info('Editng name...'),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          'lib/assets/icons/edit-pin.svg',
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'calliemosley@mail.com',
                  style: context.textStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Item Widget
  Widget _profileWidget({
    required BuildContext context,
    required String title,
    required String iconName,
    required void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              left: BorderSide(color: Color(0xffDBE9F5), width: 1),
              top: BorderSide(color: Color(0xffDBE9F5), width: 1),
              right: BorderSide.none,
              bottom: BorderSide(color: Color(0xffDBE9F5), width: 1),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('lib/assets/icons/$iconName.svg'),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: context.textStyles.bodyLarge!.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.colors.secondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign out pubup
  Widget _signOutPubup({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.h(context),
            height: 50.h(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: BoxBorder.all(color: context.colors.primary, width: 1.5),
            ),
            child: Center(
              child: SvgPicture.asset(
                'lib/assets/icons/log-out.svg',
                width: 24.w(context),
                color: context.colors.primary,
              ),
            ),
          ),
          SizedBox(height: 14.h(context)),
          Text(
            'Are You Sure You Want To\nSign Out ?',
            style: TextStyles.headingsH4.copyWith(),
          ),
          SizedBox(height: 30.h(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlobalButton(
                text: 'CANCEL',
                onTap: () => Navigator.of(context).pop(),
                height: 50.h(context),
                width: 120.w(context),
              ),
              SizedBox(width: 15.w(context)),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (BuildContext context, state) {
                  return GlobalButton(
                    text: 'SURE',
                    onTap: () => context.read<AuthBloc>().add(LogoutEvent()),
                    height: 50.h(context),
                    width: 120.w(context),
                    isFilled: false,
                    child: state is AuthLoading
                        ? const AppLoadingIndicator(size: 40, strokeWidth: 5)
                        : null,
                  );
                },
                listener: (context, state) {
                  if (state is LogoutSuccess) {
                    context.go(RoutePaths.signin);
                  }

                  if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
