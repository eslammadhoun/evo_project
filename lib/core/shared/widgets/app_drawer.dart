import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/shared/widgets/info_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: context.screenSize.width * 0.8,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () => context.pop(),
                  child: SvgPicture.asset(
                    'lib/assets/icons/close_icon.svg',
                    width: 40,
                  ),
                ),
              ),
            ),
            Spacer(),
            _profileAcount(context: context),
            const SizedBox(height: 20),
            Container(
              height: 1,
              decoration: BoxDecoration(color: Color(0xffDBE9F5)),
            ),
            const SizedBox(height: 20),
            _drawerItem(
              context: context,
              itemName: 'Categories',
              routeName: 'Categories',
            ),
            const SizedBox(height: 34),
            _drawerItem(context: context, itemName: 'Sale', routeName: 'Sale'),
            const SizedBox(height: 34),
            _drawerItem(
              context: context,
              itemName: 'New arrivals',
              routeName: 'New arrivals',
            ),
            const SizedBox(height: 34),
            _drawerItem(
              context: context,
              itemName: 'Best sellers',
              routeName: 'Best sellers',
            ),
            const SizedBox(height: 34),
            _drawerItem(
              context: context,
              itemName: 'Featured products',
              routeName: 'Featured products',
            ),
            const SizedBox(height: 48),
            InfoButtom(
              title: 'Notifications',
              iconName: 'bell',
              hasLeading: true,
            ),
            const SizedBox(height: 10),
            InfoButtom(
              title: 'Support',
              iconName: 'help-circle',
              hasLeading: false,
            ),
            Spacer(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Callie Mosley', style: context.textStyles.headlineSmall),

              Text(
                'calliemosley@mail.com',
                style: context.textStyles.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // drawer item
  Widget _drawerItem({
    required BuildContext context,
    required String itemName,
    required String routeName,
  }) {
    return Padding(
      padding: Spacing.appPadding,
      child: InkWell(
        onTap: () => AppLogger.info('Going to $itemName'),
        child: Text(
          '>  $itemName',
          style: context.textStyles.bodyMedium!.copyWith(
            color: context.colors.primary,
          ),
        ),
      ),
    );
  }
}
