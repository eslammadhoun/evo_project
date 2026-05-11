import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:evo_project/features/notifications/domain/entities/notification.dart';

class InsertNotification {
  final NotificationsRepository notificationsRepo;
  const InsertNotification({required this.notificationsRepo});

  Future<Either<Failure, void>> call({
    required NotificationEntity notification,
  }) async {
    return await notificationsRepo.insertNotification(notification);
  }
}
