import 'package:evo_project/features/wishlist/Data/repos/wishlist_repo.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';

class ToggleWishlist {
  final WishlistRepo repo;

  ToggleWishlist(this.repo);

  Future<void> call(WishlistItem item, bool exists) async {
    if (exists) {
      await repo.remove(item.productId);
    } else {
      await repo.add(item);
    }
  }
}
