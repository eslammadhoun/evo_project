import 'package:evo_project/features/wishlist/domain/repositories/wishlist_repository.dart';

class DeleteWishlistItem {
  final WishlistRepository repo;

  DeleteWishlistItem(this.repo);

  Future<void> call(String productId) {
    return repo.remove(productId);
  }
}
