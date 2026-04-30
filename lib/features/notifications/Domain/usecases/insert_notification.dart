import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/notifications/Data/repos/notifications_repo.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';

class InsertNotification {
  final NotificationsRepo notificationsRepo;
  const InsertNotification({required this.notificationsRepo});

  Future<Either<Failure, void>> call({
    required NotificationEntity notification,
  }) async {
    return await notificationsRepo.insertNotificationToDatabase(
      notification: notification,
    );
  }
}
