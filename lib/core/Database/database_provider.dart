import 'package:evo_project/core/Database/tables/cart_table.dart';
import 'package:evo_project/core/Database/tables/notification_table.dart';
import 'package:evo_project/core/Database/tables/wishlist_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final String dbPath = join(await getDatabasesPath(), 'app.db');

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await CartTable.create(db);
        await WishlistTable.create(db);
        await NotificationTable.create(db);
        print("Database Created 🔥");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await WishlistTable.create(db);
          await NotificationTable.create(db);
        }
      },
    );
  }
}
