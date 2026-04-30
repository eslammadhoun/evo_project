import 'package:evo_project/features/notifications/Data/models/notification_model.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart'
    show NotificationEntity;

extension NotificationModelMapper on NotificationModel {
  NotificationEntity toEntity() {
    return NotificationEntity(
      notificationId: notificationId,
      title: title,
      body: body,
      notificationType: notificationType,
      dateTime: dateTime,
    );
  }
}

extension NotificationEntityMapper on NotificationEntity {
  NotificationModel toModel() {
    return NotificationModel(
      notificationId: notificationId,
      title: title,
      body: body,
      notificationType: notificationType,
      dateTime: dateTime,
    );
  }
}
