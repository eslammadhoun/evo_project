import 'package:evo_project/core/Database/app_database.dart';
import 'package:evo_project/core/Database/tables/notification_table.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/notifications/Data/models/notification_model.dart';

class NotificationsDatasource {
  final AppDatabase database;
  const NotificationsDatasource({required this.database});

  // =========================== Notifications Datasource CRUD Operations ===========================
  //* CREATE
  Future<void> insertNotificationToDatabase({
    required NotificationModel notificationModel,
  }) async {
    try {
      await database.create(
        tableName: 'notification',
        data: notificationModel.toJson(),
      );
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }

  //* READ
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final List<Map<String, dynamic>> listOfNotifications = await database
          .read(tableName: NotificationTable.tableName);
      return listOfNotifications
          .map((element) => NotificationModel.fromJson(element))
          .toList();
    } catch (e) {
      throw CacheFailure(e.toString());
    }
  }
}
