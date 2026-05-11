import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:evo_project/features/wishlist/domain/entities/wishlist_item.dart';

class GetWishlist {
  final WishlistRepository repo;

  GetWishlist(this.repo);

  Future<Either<Failure, List<WishlistItem>>> call() async {
    return await repo.getWishlist();
  }
}
