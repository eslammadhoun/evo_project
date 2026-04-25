import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

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
              text: 'Wishlist',
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 20, left: 20),
                itemBuilder: (context, index) =>
                    _wishItemWidget(context: context),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemCount: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Wish item Widget
  Widget _wishItemWidget({required BuildContext context}) {
    return SizedBox(
      width: context.screenSize.width - 20,
      height: 100.h(context),
      child: Row(
        children: [
          Container(
            width: 100.h(context),
            height: 100.w(context),
            decoration: BoxDecoration(color: Color(0xffF6F8FB)),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: BoxBorder.symmetric(
                  horizontal: BorderSide(color: Color(0xffDBE9F5), width: 1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 0, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Modern undershirt',
                          style: context.textStyles.bodyMedium,
                        ),
                        InkWell(
                          onTap: () => AppLogger.info('Heart Adding'),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: SvgPicture.asset(
                              'lib/assets/icons/heart-filled.svg',
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '\$ 33.7',
                      style: context.textStyles.bodyMedium!.copyWith(
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'lib/assets/icons/star.svg',
                                width: 16,
                              ),
                              const SizedBox(width: 5),
                              Text('5,0', style: context.textStyles.bodyMedium),
                            ],
                          ),
                          InkWell(
                            onTap: () => AppLogger.info('Adding'),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                              child: SvgPicture.asset(
                                'lib/assets/icons/plus.svg',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
