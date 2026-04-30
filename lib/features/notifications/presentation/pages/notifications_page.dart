import 'package:evo_project/core/constants/spacing.dart';
import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/shared/widgets/header.dart';
import 'package:evo_project/core/shared/widgets/loading_indecator.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:evo_project/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:evo_project/features/notifications/presentation/widgets/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: Spacing.appPadding,
          child: Column(
            children: [
              HeaderWidget(
                firstWidget: FirstWidget.back,
                midWidget: MidWidget.text,
                lastWidget: LastWidget.nothing,
                text: 'Notifications',
              ),
              BlocConsumer<NotificationsBloc, NotificationsState>(
                listener: (BuildContext context, state) {},
                builder: (BuildContext context, state) {
                  if (state.getNotificationsState ==
                          GetNotificationsState.initial ||
                      state.getNotificationsState ==
                          GetNotificationsState.loading) {
                    return Center(
                      child: AppLoadingIndicator(size: 60, strokeWidth: 8),
                    );
                  } else if (state.getNotificationsState ==
                      GetNotificationsState.failure) {
                    return Center(
                      child: Text(state.getNotificationsErrorMessage!),
                    );
                  } else {
                    return Expanded(
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, index) {
                          final NotificationEntity notification =
                              state.notifications[index];
                          return NotificationWidget(notification: notification);
                        },
                        separatorBuilder: (BuildContext context, index) =>
                            SizedBox(height: 14.h(context)),
                        itemCount: state.notifications.length,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
