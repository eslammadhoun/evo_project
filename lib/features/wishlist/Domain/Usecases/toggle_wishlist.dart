import 'package:evo_project/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:evo_project/features/wishlist/domain/entities/wishlist_item.dart';

class ToggleWishlist {
  final WishlistRepository repo;

  ToggleWishlist(this.repo);

  Future<void> call(WishlistItem item, bool exists) async {
    if (exists) {
      await repo.remove(item.productId);
    } else {
      await repo.add(item);
    }
  }
}
