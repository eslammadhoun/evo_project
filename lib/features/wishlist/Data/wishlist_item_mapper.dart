import 'package:evo_project/features/wishlist/Data/models/wishlist_item_model.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';

extension WishlistMapper on WishlistItemModel {
  WishlistItem toEntity() {
    return WishlistItem(
      productId: productId,
      name: name,
      image: image,
      price: price,
      rate: rate,
    );
  }
}

extension WishlistModelMapper on WishlistItem {
  WishlistItemModel toModel() {
    return WishlistItemModel(
      productId: productId,
      name: name,
      image: image,
      price: price,
      rate: rate,
    );
  }
}
