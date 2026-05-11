import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/wishlist/domain/entities/wishlist_item.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlist();
  Future<void> add(WishlistItem item);
  Future<void> remove(String productId);
}
