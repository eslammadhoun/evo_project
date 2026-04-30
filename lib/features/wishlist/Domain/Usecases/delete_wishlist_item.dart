import 'package:evo_project/features/wishlist/Data/repos/wishlist_repo.dart';

class DeleteWishlistItem {
  final WishlistRepo repo;

  DeleteWishlistItem(this.repo);

  Future<void> call(String productId) {
    return repo.remove(productId);
  }
}
