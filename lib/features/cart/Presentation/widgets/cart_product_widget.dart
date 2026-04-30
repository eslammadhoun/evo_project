import 'package:cached_network_image/cached_network_image.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/currency_symbols.dart';
import 'package:evo_project/core/router/route_names.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_bloc.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_event.dart';
import 'package:evo_project/features/cart/Presentation/cartBloc/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CartProductWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartProductWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushNamed(
          RouteNames.productDetailsPage,
          extra: cartItem.productId,
        );
      },
      child: SizedBox(
        width: context.screenSize.width - 20,
        height: 100.h(context),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffF6F8FB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                child: CachedNetworkImage(
                  imageUrl: cartItem.image,
                  fit: BoxFit.fill,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(
                    child: SvgPicture.asset('lib/assets/icons/app_logo.svg'),
                  ),
                ),
              ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.screenSize.width * 0.50,
                            child: Text(
                              cartItem.name,
                              style: context.textStyles.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            CurrencySymbols.format.format(cartItem.price),
                            style: context.textStyles.bodyMedium!.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'size: ${cartItem.size}',
                            style: context.textStyles.bodyMedium,
                          ),
                        ],
                      ),
                      BlocSelector<CartBloc, CartState, int>(
                        selector: (state) {
                          try {
                            final CartItem item = state.cartProducts
                                .where(
                                  (eachProduct) =>
                                      eachProduct.productId ==
                                      cartItem.productId,
                                )
                                .first;
                            return item.quantity;
                          } catch (e) {
                            return 0;
                          }
                        },
                        builder: (context, quantity) => Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => context.read<CartBloc>().add(
                                UpdateProductQuantityEvent(
                                  increment: true,
                                  productId: cartItem.productId,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.add),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                quantity.toString(),
                                style: context.textStyles.bodySmall,
                              ),
                            ),
                            InkWell(
                              onTap: () => quantity == 1
                                  ? context.read<CartBloc>().add(
                                      DeleteProductFromCartEvent(
                                        productId: cartItem.productId,
                                      ),
                                    )
                                  : context.read<CartBloc>().add(
                                      UpdateProductQuantityEvent(
                                        increment: false,
                                        productId: cartItem.productId,
                                      ),
                                    ),

                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.remove),
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
      ),
    );
  }
}
