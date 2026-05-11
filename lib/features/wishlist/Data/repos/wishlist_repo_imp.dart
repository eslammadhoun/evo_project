import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/errors/repository_error_handler.dart';
import 'package:evo_project/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:evo_project/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:evo_project/features/wishlist/data/wishlist_item_mapper.dart';
import 'package:evo_project/features/wishlist/domain/entities/wishlist_item.dart';

import 'package:evo_project/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepoImp with RepositoryErrorHandler implements WishlistRepository {
  final WishlistDatasource datasource;

  WishlistRepoImp({required this.datasource});

  Future<Either<Failure, List<WishlistItem>>> getWishlist() {
    return handleRepositoryCall(() async {
      final List<WishlistItemModel> wishlist = await datasource.getWishlist();
      return wishlist.map((element) => element.toEntity()).toList();
    });
  }

  Future<void> add(WishlistItem item) async {
    await datasource.insertWishlistItem(wishlistItemModel: item.toModel());
  }

  Future<void> remove(String productId) async {
    await datasource.deleteWishlistItem(productId: productId);
  }
}
