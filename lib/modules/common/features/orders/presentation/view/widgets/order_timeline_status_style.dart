import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';

extension OrderTimelineStatusStyle on OrderTimelineStatus {
  String get titleKey {
    switch (this) {
      case OrderTimelineStatus.pending:
        return LocaleKeys.orders_details_status_pending_title;
      case OrderTimelineStatus.accepted:
        return LocaleKeys.orders_details_status_accepted_title;
      case OrderTimelineStatus.preparing:
        return LocaleKeys.orders_details_status_preparing_title;
      case OrderTimelineStatus.onTheWay:
        return LocaleKeys.orders_details_status_on_the_way_title;
      case OrderTimelineStatus.delivered:
        return LocaleKeys.orders_details_status_delivered_title;
      case OrderTimelineStatus.cancelled:
        return LocaleKeys.orders_details_status_cancelled_title;
      case OrderTimelineStatus.rejected:
        return LocaleKeys.orders_details_status_rejected_title;
    }
  }

  String get subtitleKey {
    switch (this) {
      case OrderTimelineStatus.pending:
        return LocaleKeys.orders_details_status_pending_subtitle;
      case OrderTimelineStatus.accepted:
        return LocaleKeys.orders_details_status_accepted_subtitle;
      case OrderTimelineStatus.preparing:
        return LocaleKeys.orders_details_status_preparing_subtitle;
      case OrderTimelineStatus.onTheWay:
        return LocaleKeys.orders_details_status_on_the_way_subtitle;
      case OrderTimelineStatus.delivered:
        return LocaleKeys.orders_details_status_delivered_subtitle;
      case OrderTimelineStatus.cancelled:
        return LocaleKeys.orders_details_status_cancelled_subtitle;
      case OrderTimelineStatus.rejected:
        return LocaleKeys.orders_details_status_rejected_subtitle;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderTimelineStatus.pending:
        return Icons.schedule_rounded;
      case OrderTimelineStatus.accepted:
        return Icons.task_alt_rounded;
      case OrderTimelineStatus.preparing:
        return Icons.inventory_2_outlined;
      case OrderTimelineStatus.onTheWay:
        return Icons.local_shipping_outlined;
      case OrderTimelineStatus.delivered:
        return Icons.verified_outlined;
      case OrderTimelineStatus.cancelled:
        return Icons.cancel_outlined;
      case OrderTimelineStatus.rejected:
        return Icons.block_rounded;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case OrderTimelineStatus.pending:
        return context.warningColor;
      case OrderTimelineStatus.accepted:
        return context.primaryColor;
      case OrderTimelineStatus.preparing:
        return context.secondarySwatch.shade500;
      case OrderTimelineStatus.onTheWay:
        return context.accentSwatch.shade500;
      case OrderTimelineStatus.delivered:
        return context.successColor;
      case OrderTimelineStatus.cancelled:
      case OrderTimelineStatus.rejected:
        return context.errorColor;
    }
  }

  Color softColor(BuildContext context) =>
      color(context).withValues(alpha: 0.12);

  Color textColor(BuildContext context, {required bool isActive}) {
    if (isActive) return color(context);
    return context.greySwatch.shade600;
  }
}
