import 'package:evo_project/core/extensions/extensions.dart';
import 'package:evo_project/core/helpers/date_formater.dart';
import 'package:evo_project/features/notifications/Data/models/notification_model.dart';
import 'package:evo_project/features/notifications/Domain/entites/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationEntity notification;
  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: BoxBorder.all(color: Color(0xffDBE9F5)),
        color: Color(0xffDBE9F5).withAlpha(38),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24.w(context),
                  height: 24.h(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        notification.notificationType == NotificationType.alert
                        ? Color(0xffEECC55)
                        : notification.notificationType ==
                              NotificationType.success
                        ? Color(0xff00824B)
                        : Color(0xffF84C6B),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        notification.notificationType == NotificationType.alert
                            ? 'lib/assets/icons/alert.svg'
                            : notification.notificationType ==
                                  NotificationType.success
                            ? 'lib/assets/icons/check.svg'
                            : 'lib/assets/icons/gift.svg',
                        width: 16.w(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w(context)),
                Text(
                  notification.title,
                  style: context.textStyles.bodyMedium!.copyWith(
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h(context)),
            Text(notification.body, style: context.textStyles.bodySmall),
            SizedBox(height: 14.h(context)),
            Container(height: 1, color: Color(0xffCED6E1)),
            SizedBox(height: 14.h(context)),
            Text(
              dateFormater(dateTime: notification.dateTime),
              style: context.textStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
