import 'package:evo_project/features/cart/Data/models/cart_item_model.dart';
import 'package:evo_project/features/cart/Domain/entites/cart_item.dart';

extension CartItemMapper on CartItemModel {
  CartItem toEntity() {
    return CartItem(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity,
      image: image,
      size: size,
    );
  }
}

extension CartItemModelMapper on CartItem {
  CartItemModel toModel() {
    return CartItemModel(
      productId: productId,
      name: name,
      price: price,
      quantity: quantity,
      image: image,
      size: size,
    );
  }
}
