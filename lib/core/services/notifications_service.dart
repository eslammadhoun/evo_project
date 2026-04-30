import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await notifications.initialize(settings: settings);
  }

  static const NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'basic_channel',
      'Basic Notifications',
      channelDescription: 'General notifications',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
  );

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    print('Notification');
    await notifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(),
    );
  }
}
