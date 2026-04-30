import 'package:evo_project/core/Database/app_database.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/wishlist/Data/models/wishlist_item_model.dart';

class WishlistDatesource {
  final AppDatabase appDatabase;
  const WishlistDatesource({required this.appDatabase});

  //! ======================== Wishlist Datasource CRUD Operations ========================
  //!* CREATE
  Future<void> insertWishlistItem({
    required WishlistItemModel wishlistItemModel,
  }) async {
    try {
      await appDatabase.insertWishlist(wishlistItemModel.toJson());
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  //!* READ
  Future<List<WishlistItemModel>> getWishlist() async {
    try {
      final List<Map<String, dynamic>> data = await appDatabase.getWishlist();
      return data
          .map((element) => WishlistItemModel.fromJson(element))
          .toList();
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  //!* UPDATE
  //!* DELETE
  Future<void> deleteWishlistItem({required String productId}) async {
    try {
      await appDatabase.deleteFromWishlist(productId);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
