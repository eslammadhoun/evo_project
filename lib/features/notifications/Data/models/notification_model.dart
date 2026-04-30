enum NotificationType { alert, success, gift }

class NotificationModel {
  final String notificationId;
  final String title;
  final String body;
  final NotificationType notificationType;
  final DateTime dateTime;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.notificationType,
    required this.dateTime,
  });

  // 🔥 fromJson (تصحيح كامل)
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'],
      title: json['title'] ?? 'notification title',
      body: json['body'] ?? '',

      notificationType: NotificationType.values.firstWhere(
        (e) => e.name == json['notification_type'],
        orElse: () => NotificationType.alert,
      ),

      dateTime: DateTime.parse(json['date_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'title': title,
      'body': body,

      // 👇 enum → String
      'notification_type': notificationType.name,

      // 👇 DateTime → String
      'date_time': dateTime.toIso8601String(),
    };
  }
}
