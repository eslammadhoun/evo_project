import '../../Domain/Entites/wishlist_item.dart';

abstract class WishlistEvent {}

class GetWishlistEvent extends WishlistEvent {}

class ToggleWishlistEvent extends WishlistEvent {
  final WishlistItem item;

  ToggleWishlistEvent(this.item);
}
