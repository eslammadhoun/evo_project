import 'package:evo_project/core/Database/database_provider.dart';
import 'package:evo_project/core/Database/tables/cart_table.dart';
import 'package:evo_project/core/Database/tables/notification_table.dart';
import 'package:evo_project/core/Database/tables/wishlist_table.dart';
import 'package:sqflite/sqlite_api.dart';

class AppDatabase {
  final DatabaseProvider provider;

  AppDatabase(this.provider);

  Future<void> create({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    final db = await provider.database;
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> read({required String tableName}) async {
    final db = await provider.database;
    return await db.query(tableName);
  }

  Future<void> delete({
    required String tableName,
    String? where,
    List<Object?>? listWhere,
  }) async {
    final db = await provider.database;
    await db.delete(tableName, where: where, whereArgs: listWhere);
  }

  // CART
  Future<void> insertCart(Map<String, dynamic> data) async {
    final db = await provider.database;
    await db.insert('cart', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final db = await provider.database;
    return await db.query('cart');
  }

  Future<void> deleteCartItem(String productId) async {
    final db = await provider.database;
    await db.delete('cart', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<void> updateProductQuantity({
    required bool increment,
    required String productId,
  }) async {
    final Database db = await provider.database;

    await db.rawUpdate(
      '''
        UPDATE cart
        SET quantity = CASE
          WHEN ? = 1 THEN quantity + 1
          ELSE MAX(quantity - 1, 1)
        END
        WHERE productId = ?
      ''',
      [increment ? 1 : 0, productId],
    );
  }

  // ───────────── WISHLIST ─────────────

  Future<void> insertWishlist(Map<String, dynamic> data) async {
    final db = await provider.database;

    await db.insert(
      'wishlist',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWishlist() async {
    final db = await provider.database;
    return await db.query('wishlist');
  }

  Future<void> deleteFromWishlist(String productId) async {
    final db = await provider.database;

    await db.delete('wishlist', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<bool> isInWishlist(String productId) async {
    final db = await provider.database;

    final result = await db.query(
      'wishlist',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    return result.isNotEmpty;
  }

  Future<void> deleteAllDatabasse() async {
    await delete(tableName: CartTable.tableName);
    await delete(tableName: WishlistTable.tableName);
    await delete(tableName: NotificationTable.tableName);
  }
}
