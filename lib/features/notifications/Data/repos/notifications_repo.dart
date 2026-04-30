import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/notifications/Data/datasources/notifications_datasource.dart';
import 'package:evo_project/features/notifications/Data/models/notification_model.dart';
import 'package:evo_project/features/notifications/Data/notification_mapper.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';

class NotificationsRepo {
  final NotificationsDatasource notificationsDatasource;
  const NotificationsRepo({required this.notificationsDatasource});

  //* CREATE
  Future<Either<Failure, void>> insertNotificationToDatabase({
    required NotificationEntity notification,
  }) async {
    try {
      return Right(
        await notificationsDatasource.insertNotificationToDatabase(
          notificationModel: notification.toModel(),
        ),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(CacheFailure(e.toString()));
    }
  }

  //* READ
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final List<NotificationModel> notificationsModelsList =
          await notificationsDatasource.getNotifications();
      return Right(
        notificationsModelsList.map((model) => model.toEntity()).toList(),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(CacheFailure(e.toString()));
    }
  }

  /*
    try {

    } catch (e) {
      if (e is Failure) {
        return Left(CacheFailure(e.message));
      }
      return Left(CacheFailure(e.toString()));
    } 
  */
}
