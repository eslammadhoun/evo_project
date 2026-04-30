import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/currency_symbols.dart';
import 'package:evo_project/core/logger/app_logger.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/theme/text_styles.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              firstWidget: FirstWidget.back,
              midWidget: MidWidget.text,
              lastWidget: LastWidget.nothing,
              text: 'Checkout',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [
                  Padding(
                    padding: Spacing.appPadding,
                    child: cartBill(context: context),
                  ),
                  SizedBox(height: 14.h(context)),
                  navigationItem(
                    context: context,
                    iconName: 'map-pin',
                    title: 'Shipping details',
                    subTitle: '8000 S Kirkland Ave, Chicago, IL 6065...',
                  ),
                  SizedBox(height: 14.h(context)),
                  navigationItem(
                    context: context,
                    iconName: 'credit-card',
                    title: 'Payment method',
                    subTitle: '**** 4864',
                  ),
                  SizedBox(height: 30.h(context)),
                  Padding(
                    padding: Spacing.appPadding,
                    child: GlobalTextField(
                      hintText: 'Enter your comment',
                      text: 'COMMENT',
                      fieldType: TextFormFieldType.name,
                      textInputType: TextInputType.text,
                      validationMode: AutovalidateMode.disabled,
                      controller: TextEditingController(),
                      maxLines: 5,
                    ),
                  ),
                  SizedBox(height: 23.h(context)),
                  Padding(
                    padding: Spacing.appPadding,
                    child: GlobalButton(
                      text: 'CONFIRM ORDER',
                      onTap: () {},
                      height: 50.h(context),
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

  // Build Cart Bill Widget
  Widget cartBill({required BuildContext context}) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) => Container(
        decoration: BoxDecoration(
          color: Color(0xffDBE9F5).withAlpha(39),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Color(0xffDBE9F5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Order', style: TextStyles.headingsH4),
                  Text(
                    CurrencySymbols.format.format(state.cartBill!['total']),
                    style: TextStyles.headingsH4,
                  ),
                ],
              ),
              SizedBox(height: 20.h(context)),
              Container(height: 1, color: Color(0xffDBE9F5)),
              SizedBox(height: 20.h(context)),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  final CartItem cartItem = state.cartProducts[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${cartItem.name}, ${cartItem.size}',
                        style: context.textStyles.bodySmall,
                      ),
                      Text(
                        '${cartItem.quantity} x ${CurrencySymbols.format.format(cartItem.price)}',
                        style: context.textStyles.bodySmall,
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, index) =>
                    SizedBox(height: 10.h(context)),
                itemCount: state.cartProducts.length,
              ),
              SizedBox(height: 10.h(context)),
              state.hasDiscount
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount', style: context.textStyles.bodySmall),
                        Text(
                          '- ${CurrencySymbols.format.format((state.discountPercentage * state.cartBill!['sub_total']))}',
                          style: context.textStyles.bodySmall,
                        ),
                      ],
                    )
                  : SizedBox(),
              state.hasDiscount ? SizedBox(height: 10.h(context)) : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Delivery', style: context.textStyles.bodySmall),
                  Text(
                    CurrencySymbols.format.format(
                      state.cartBill!['delivery_cost'],
                    ),
                    style: context.textStyles.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build NavigationItem
  Widget navigationItem({
    required BuildContext context,
    required String iconName,
    required String title,
    required String subTitle,
  }) {
    return InkWell(
      onTap: () => AppLogger.info('Going to shipping details Page'),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Container(
          decoration: BoxDecoration(
            border: BoxBorder.fromLTRB(
              left: BorderSide(color: Color(0xffDBE9F5)),
              top: BorderSide(color: Color(0xffDBE9F5)),
              bottom: BorderSide(color: Color(0xffDBE9F5)),
              right: BorderSide(color: Color(0xffDBE9F5)),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              bottomLeft: Radius.circular(5),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('lib/assets/icons/$iconName.svg'),
                      SizedBox(width: 10.w(context)),
                      Text(
                        'Shipping details',
                        style: context.textStyles.headlineSmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h(context)),
                  Text(subTitle, style: context.textStyles.bodySmall),
                ],
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
