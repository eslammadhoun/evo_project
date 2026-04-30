import 'package:evo_project/features/notifications/Data/models/notification_model.dart';

class NotificationEntity {
  final String notificationId;
  final String title;
  final String body;
  final NotificationType notificationType;
  final DateTime dateTime;

  NotificationEntity({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.notificationType,
    required this.dateTime,
  });
}
