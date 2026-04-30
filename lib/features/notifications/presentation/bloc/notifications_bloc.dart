import 'package:evo_project/core/helpers/bloc_request_handler.dart';
import 'package:evo_project/features/notifications/Domain/usecases/get_notifications.dart';
import 'package:evo_project/features/notifications/Domain/usecases/insert_notification.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotifications getNotificationsUsecase;
  final InsertNotification insertNotificationUsecase;
  NotificationsBloc({
    required this.getNotificationsUsecase,
    required this.insertNotificationUsecase,
  }) : super(NotificationsState.initial()) {
    on<GetNotificationsEvent>(getNotifications);
    on<InsertNotificationEvent>(insertNotification);
  }

  Future<void> getNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    await blocRequestHandeler(
      request: () => getNotificationsUsecase(),
      onLoading: () => emit(
        state.copyWith(getNotificationsState: GetNotificationsState.loading),
      ),
      onSuccess: (list) {
        list.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        emit(
          state.copyWith(
            getNotificationsState: GetNotificationsState.success,
            notifications: list,
          ),
        );
        print('Notification Count: ${list.length}');
      },
      onError: (error) => emit(
        state.copyWith(
          getNotificationsState: GetNotificationsState.failure,
          getNotificationsErrorMessage: error,
        ),
      ),
    );
  }

  Future<void> insertNotification(
    InsertNotificationEvent event,
    Emitter<NotificationsState> state,
  ) async {
    await insertNotificationUsecase(notification: event.notificationEntity);
    print('Notification Added');
  }
}
