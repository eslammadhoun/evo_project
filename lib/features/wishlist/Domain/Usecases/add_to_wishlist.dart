import 'package:evo_project/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:evo_project/features/wishlist/domain/entities/wishlist_item.dart';

class AddToWishlist {
  final WishlistRepository repo;

  AddToWishlist(this.repo);

  Future<void> call({required WishlistItem item}) {
    return repo.add(item);
  }
}
