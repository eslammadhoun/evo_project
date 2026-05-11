import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/core/errors/repository_error_handler.dart';
import 'package:evo_project/features/notifications/data/datasources/notifications_datasource.dart';
import 'package:evo_project/features/notifications/data/models/notification_model.dart';
import 'package:evo_project/features/notifications/data/notification_mapper.dart';
import 'package:evo_project/features/notifications/domain/entities/notification.dart';

import 'package:evo_project/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepoImp
    with RepositoryErrorHandler
    implements NotificationsRepository {
  final NotificationsDatasource notificationsDatasource;
  NotificationsRepoImp({required this.notificationsDatasource});

  @override
  Future<Either<Failure, void>> insertNotification(
    NotificationEntity notification,
  ) {
    return handleRepositoryCall(() async {
      return await notificationsDatasource.insertNotificationToDatabase(
        notificationModel: notification.toModel(),
      );
    });
  }

  Future<Either<Failure, List<NotificationEntity>>> getNotifications() {
    return handleRepositoryCall(() async {
      final List<NotificationModel> models = await notificationsDatasource
          .getNotifications();
      return models.map((model) => model.toEntity()).toList();
    });
  }
}
