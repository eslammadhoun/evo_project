import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';

class CartEvent {
  const CartEvent();
}

class GetCartProductsEvent extends CartEvent {}

class AddProductToCartEvent extends CartEvent {
  final CartItem cartItem;
  const AddProductToCartEvent({required this.cartItem});
}

class DeleteProductFromCartEvent extends CartEvent {
  final String productId;
  const DeleteProductFromCartEvent({required this.productId});
}

class UpdateProductQuantityEvent extends CartEvent {
  final bool increment;
  final String productId;
  const UpdateProductQuantityEvent({
    required this.increment,
    required this.productId,
  });
}

class ApplyPromoCodeEvent extends CartEvent {
  final String promoCode;
  const ApplyPromoCodeEvent({required this.promoCode});
}

class GetCartDiscountEvent extends CartEvent {}

class SetCartDiscountEvent extends CartEvent {
  final bool userHaveDiscount;
  final double cartDiscount;
  const SetCartDiscountEvent({
    required this.userHaveDiscount,
    required this.cartDiscount,
  });
}
