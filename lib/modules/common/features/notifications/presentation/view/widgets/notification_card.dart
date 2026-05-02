import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../data/model/notification_model.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.timeLabel,
    this.onTap,
  });

  final NotificationModel notification;
  final String timeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = notification.isOffer
        ? context.primaryColor
        : notification.isReminder
        ? context.errorColor
        : context.secondaryColor;

    final surfaceColor = accentColor.withValues(alpha: 0.08);
    final borderColor = notification.isRead
        ? Colors.transparent
        : accentColor.withValues(alpha: 0.35);

    return Row(
          children: [
            Text(
              timeLabel,
              style: context.bodyMedium.medium.s14.setColor(
                context.greySwatch.shade500,
              ),
            ).withWidth(92),
            12.gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  notification.title,
                  style: context.titleLarge.bold.s18,
                  textAlign: TextAlign.end,
                ),
                8.gap,
                Text(
                  notification.message,
                  style: context.bodyLarge.regular.s16.setColor(
                    context.greySwatch.shade600,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ).expand(),
            16.gap,
            Icon(
              notification.isOffer
                  ? Icons.local_offer_rounded
                  : Icons.alarm_rounded,
              color: accentColor,
              size: 24,
            ).center().setContainerToView(
              width: 56,
              height: 56,
              radius: 28,
              color: surfaceColor,
            ),
          ],
        )
        .paddingAll(18)
        .setContainerToView(
          radius: 24,
          borderColor: borderColor,
          color: context.scaffoldBackgroundColor,
        )
        .onTap(onTap, borderRadius: 24.borderRadius);
  }
}
