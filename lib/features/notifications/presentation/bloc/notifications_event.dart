import 'package:evo_project/features/notifications/Domain/entites/notification.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class InsertNotificationEvent extends NotificationsEvent {
  final NotificationEntity notificationEntity;
  const InsertNotificationEvent({required this.notificationEntity});
}

class GetNotificationsEvent extends NotificationsEvent {}
