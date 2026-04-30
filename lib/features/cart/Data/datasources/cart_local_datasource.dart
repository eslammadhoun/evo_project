import 'package:evo_project/core/Database/app_database.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/services/app_preferences.dart';
import 'package:evo_project/features/cart/Data/models/cart_item_model.dart';

class CartLocalDataSource {
  final AppDatabase appDatabase;
  final AppPreferences appPreferences;
  CartLocalDataSource({
    required this.appDatabase,
    required this.appPreferences,
  });

  // CREATE
  Future<void> addProductToCart({required CartItemModel cartItemModel}) async {
    try {
      await appDatabase.insertCart(cartItemModel.toJson());
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  // READ
  Future<List<CartItemModel>> getItems() async {
    try {
      final result = await appDatabase.getCart();
      return result.map((e) => CartItemModel.fromJson(e)).toList();
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  // UPDATE
  Future<void> updateProductQuantity({
    required bool increment,
    required String productId,
  }) async {
    try {
      await appDatabase.updateProductQuantity(
        increment: increment,
        productId: productId,
      );
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  // DELETE
  Future<void> deleteItem(String productId) async {
    try {
      await appDatabase.deleteCartItem(productId);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  // Get Cart Discount State
  Future<Map<String, dynamic>> getDiscountState() async {
    try {
      final bool userHaveDiscount = appPreferences.userHaveDicount();
      final double cartDiscount = appPreferences.getCartDiscount();
      return {'have_discount': userHaveDiscount, 'cart_discount': cartDiscount};
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  // Set Cart Discount State
  Future<void> setCartDiscountState({
    required bool userHaveDiscount,
    required double cartDiscount,
  }) async {
    try {
      await appPreferences.setDiscount(cartDiscount);
      await appPreferences.setUserHavingDiscount(userHaveDiscount);
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
