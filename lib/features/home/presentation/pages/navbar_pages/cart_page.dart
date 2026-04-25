import 'dart:ui';

import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:evo_project/core/theme/text_styles.dart';
import 'package:evo_project/features/home/presentation/widgets/cart_product_wwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  final bool isCartEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: SafeArea(
        child: isCartEmpty
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: GlobalButton(
                    text: 'SHOP NOW',
                    onTap: () =>
                        StatefulNavigationShell.of(context).goBranch(0),
                    height: 50.h(context),
                    isFilled: true,
                  ),
                ),
              )
            : Column(
                children: [
                  HeaderWidget(
                    firstWidget: FirstWidget.menu,
                    midWidget: MidWidget.text,
                    lastWidget: LastWidget.cart,
                    text: 'Order',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: SizedBox(
                      height: 200.h(context) + 15,
                      width: context.screenSize.width - 20,
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 20),
                        itemBuilder: (context, index) => Dismissible(
                          direction: DismissDirection.endToStart,
                          key: Key(''),
                          background: Container(
                            color: const Color(0xffF84C6B),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: SvgPicture.asset(
                                  'lib/assets/icons/trash.svg',
                                ),
                              ),
                            ),
                          ),
                          child: CartProductWidget(),
                        ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                        itemCount: 5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h(context)),
                  Expanded(
                    child: Padding(
                      padding: Spacing.appPadding,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: GlobalTextField(
                                  text: 'Enter the voucher',
                                  fieldType: TextFormFieldType.name,
                                  textInputType: TextInputType.text,
                                  controller: TextEditingController(),
                                  isRequierdValidator: true,
                                  hintText: 'Enter your promocode',
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 100.w(context),
                                height: 50.h(context),
                                child: GlobalButton(
                                  text: 'APPLY',
                                  onTap: () => print('Applying'),
                                  height: 50.h(context),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            width: context.screenSize.width - 20,
                            height: 148.h(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: BoxBorder.all(
                                color: Color(0xffDBE9F5),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Subtotal',
                                        style: context.textStyles.headlineSmall!
                                            .copyWith(
                                              color: context.colors.primary,
                                            ),
                                      ),
                                      Text(
                                        '\$ 296',
                                        style: context.textStyles.bodyMedium!
                                            .copyWith(
                                              color: context.colors.primary,
                                              fontWeight: AppTypography.medium,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 13.h(context)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery',
                                        style: context.textStyles.bodyMedium,
                                      ),
                                      Text(
                                        '\$ 15',
                                        style: context.textStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 14.h(context)),
                                  Container(
                                    height: 1,
                                    color: Color(0xffDBE9F5),
                                  ),
                                  SizedBox(height: 20.h(context)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyles.headingsH4,
                                      ),
                                      Text(
                                        '\$ 311.5',
                                        style: TextStyles.headingsH4,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h(context)),
                          GlobalButton(
                            text: 'PROCCED TO CHECKOUT',
                            onTap: () =>
                                StatefulNavigationShell.of(context).goBranch(0),
                            height: 50.h(context),
                            isFilled: true,
                          ),
                          SizedBox(height: 20.h(context)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
