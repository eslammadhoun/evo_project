import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/currency_symbols.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/core/shared/widgets/app_drawer.dart';
import 'package:evo_project/core/shared/widgets/global_button.dart';
import 'package:evo_project/core/shared/widgets/global_text_field.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/core/theme/app_typography.dart';
import 'package:evo_project/core/theme/text_styles.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_event.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_state.dart';
import 'package:evo_project/features/cart/Presentation/widgets/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final TextEditingController promocodeTextField = TextEditingController();
  final GlobalKey<FormState> promoCodeFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: AppDrawer(),
      body: SafeArea(
        child: BlocSelector<CartBloc, CartState, bool>(
          selector: (state) => state.cartProducts.isEmpty,
          builder: (context, isEmpty) {
            if (isEmpty) {
              return Align(
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
              );
            } else {
              return Column(
                children: [
                  HeaderWidget(
                    firstWidget: FirstWidget.menu,
                    midWidget: MidWidget.text,
                    lastWidget: LastWidget.cart,
                    text: 'Order',
                  ),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),

                          padding: EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            MediaQuery.of(context).viewInsets.bottom + 20,
                          ),

                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),

                            child: IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  cartProductsList(context: context),

                                  SizedBox(height: 20.h(context)),

                                  promoCodeSectiopn(context: context),

                                  const Spacer(),

                                  cartBillSection(context: context),

                                  SizedBox(height: 20.h(context)),

                                  GlobalButton(
                                    text: 'PROCCED TO CHECKOUT',
                                    onTap: () => context.pushNamed(
                                      RouteNames.checkoutPage,
                                    ),
                                    height: 50.h(context),
                                    isFilled: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  // build cart products list
  Widget cartProductsList({required BuildContext context}) {
    return BlocConsumer<CartBloc, CartState>(
      listenWhen: (previous, current) =>
          previous.deleteProductFromCartState !=
          current.deleteProductFromCartState,
      listener: (context, state) {
        if (state.deleteProductFromCartState ==
            DeleteProductFromCartState.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'faild to add product to cart, Try again: ${state.deleteProductFromCartErrorMessage}',
              ),
            ),
          );
        }
        if (state.deleteProductFromCartState ==
            DeleteProductFromCartState.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Product deleted from cart')));
        }
      },
      builder: (context, state) {
        if (state.getCartProductsState == GetCartProductsState.initial ||
            state.getCartProductsState == GetCartProductsState.laoding) {
          return Center(child: AppLoadingIndicator(size: 60, strokeWidth: 8));
        } else if (state.getCartProductsState == GetCartProductsState.failure &&
            state.getCartErrorMessage != null) {
          return Center(child: Text(state.getCartErrorMessage!));
        } else {
          return SizedBox(
            height: state.cartProducts.length == 1
                ? 115.h(context)
                : 230.h(context),
            width: context.screenSize.width - 20,
            child: ListView.separated(
              padding: EdgeInsets.only(top: 20),
              itemBuilder: (context, index) => Dismissible(
                direction: DismissDirection.endToStart,
                key: Key(state.cartProducts[index].productId),
                background: Container(
                  color: const Color(0xffF84C6B),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SvgPicture.asset('lib/assets/icons/trash.svg'),
                    ),
                  ),
                ),
                child: CartProductWidget(cartItem: state.cartProducts[index]),
                onDismissed: (direction) => context.read<CartBloc>().add(
                  DeleteProductFromCartEvent(
                    productId: state.cartProducts[index].productId,
                  ),
                ),
              ),
              separatorBuilder: (context, index) => const SizedBox(height: 15),
              itemCount: state.cartProducts.length,
            ),
          );
        }
      },
    );
  }

  // Build Promo code section
  Widget promoCodeSectiopn({required BuildContext context}) {
    return BlocSelector<CartBloc, CartState, bool>(
      selector: (state) {
        return state.hasDiscount;
      },
      builder: (context, state) {
        return Form(
          key: promoCodeFormKey,
          child: state
              ? Row(
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    Text(
                      'Promocode applied',
                      style: context.textStyles.bodyMedium,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: GlobalTextField(
                        text: 'Enter the voucher',
                        validationMode: AutovalidateMode.disabled,
                        fieldType: TextFormFieldType.name,
                        textInputType: TextInputType.text,
                        controller: promocodeTextField,

                        hintText: 'Enter your promocode',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter promocode';
                          }

                          if (value != 'xyz') {
                            return 'Wrong promocode';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 100.w(context),
                      height: 50.h(context),
                      child: GlobalButton(
                        text: 'APPLY',
                        onTap: () {
                          if (promoCodeFormKey.currentState!.validate()) {
                            context.read<CartBloc>().add(
                              ApplyPromoCodeEvent(
                                promoCode: promocodeTextField.text,
                              ),
                            );
                          }
                        },
                        height: 50.h(context),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // Build Cart Bill section
  Widget cartBillSection({required BuildContext context}) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, state) {
        return Container(
          width: context.screenSize.width - 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: BoxBorder.all(color: Color(0xffDBE9F5), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: context.textStyles.headlineSmall!.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    Text(
                      CurrencySymbols.format.format(
                        state.cartBill!['sub_total'],
                      ),
                      style: context.textStyles.bodyMedium!.copyWith(
                        color: context.colors.primary,
                        fontWeight: AppTypography.medium,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 13.h(context)),
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
                state.hasDiscount
                    ? SizedBox(height: 10.h(context))
                    : SizedBox(),
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
                SizedBox(height: 14.h(context)),
                Container(height: 1, color: Color(0xffDBE9F5)),
                SizedBox(height: 20.h(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: TextStyles.headingsH4),
                    Text(
                      CurrencySymbols.format.format(state.cartBill!['total']),

                      style: TextStyles.headingsH4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
