import 'package:evo_project/features/wishlist/Data/repos/wishlist_repo.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';

class AddToWishlist {
  final WishlistRepo repo;

  AddToWishlist(this.repo);

  Future<void> call({required WishlistItem item}) {
    return repo.add(item);
  }
}
