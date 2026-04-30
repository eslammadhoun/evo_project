import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/wishlist/Data/datasources/wishlist_datesource.dart';
import 'package:evo_project/features/wishlist/Data/models/wishlist_item_model.dart';
import 'package:evo_project/features/wishlist/Data/wishlist_item_mapper.dart';
import 'package:evo_project/features/wishlist/Domain/Entites/wishlist_item.dart';

class WishlistRepo {
  final WishlistDatesource datasource;

  WishlistRepo({required this.datasource});

  Future<Either<Failure, List<WishlistItem>>> getWishlist() async {
    try {
      final List<WishlistItemModel> wishlist = await datasource.getWishlist();
      return Right(wishlist.map((element) => element.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<void> add(WishlistItem item) async {
    await datasource.insertWishlistItem(wishlistItemModel: item.toModel());
  }

  Future<void> remove(String productId) async {
    await datasource.deleteWishlistItem(productId: productId);
  }
}
