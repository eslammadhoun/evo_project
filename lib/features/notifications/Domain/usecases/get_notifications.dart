import 'package:dartz/dartz.dart';
import 'package:evo_project/core/errors/failures.dart';
import 'package:evo_project/features/notifications/Data/repos/notifications_repo.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';

class GetNotifications {
  final NotificationsRepo notificationsRepo;
  const GetNotifications({required this.notificationsRepo});

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await notificationsRepo.getNotifications();
  }
}
