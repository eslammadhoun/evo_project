import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/wishlist/Data/repos/wishlist_repo.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';

class GetWishlist {
  final WishlistRepo repo;

  GetWishlist(this.repo);

  Future<Either<Failure, List<WishlistItem>>> call() async {
    return await repo.getWishlist();
  }
}
