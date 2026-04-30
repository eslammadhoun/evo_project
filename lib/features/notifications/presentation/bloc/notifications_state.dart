import 'package:equatable/equatable.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';

enum GetNotificationsState { initial, loading, success, failure }

class NotificationsState extends Equatable {
  final GetNotificationsState getNotificationsState;
  final List<NotificationEntity> notifications;
  final String? getNotificationsErrorMessage;

  const NotificationsState({
    required this.getNotificationsState,
    required this.notifications,
    this.getNotificationsErrorMessage,
  });

  factory NotificationsState.initial() {
    return NotificationsState(
      getNotificationsState: GetNotificationsState.initial,
      notifications: [],
    );
  }

  NotificationsState copyWith({
    GetNotificationsState? getNotificationsState,
    List<NotificationEntity>? notifications,
    String? getNotificationsErrorMessage,
  }) {
    return NotificationsState(
      getNotificationsState:
          getNotificationsState ?? this.getNotificationsState,
      notifications: notifications ?? this.notifications,
      getNotificationsErrorMessage:
          getNotificationsErrorMessage ?? this.getNotificationsErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
    getNotificationsState,
    notifications,
    getNotificationsErrorMessage,
  ];
}
