import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';

class OrdersProgressStep extends StatelessWidget {
  const OrdersProgressStep({
    super.key,
    required this.stage,
    required this.orderStatus,
    required this.activeStage,
  });

  final OrderProgressStage stage;
  final OrderTabStatus orderStatus;
  final OrderProgressStage activeStage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _iconBackgroundColor(context),
            shape: BoxShape.circle,
          ),
          child: _buildIcon(context),
        ),
        10.gap,
        Text(
          _label.tr(),
          style: context.bodyMedium.regular.setColor(
            context.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).expand();
  }

  Widget _buildIcon(BuildContext context) {
    if (orderStatus == OrderTabStatus.cancelled) {
      return Icon(
        Icons.close_rounded,
        size: 18,
        color: context.colorScheme.onPrimary,
      ).center();
    }

    if (orderStatus == OrderTabStatus.completed || stage.index < activeStage.index) {
      return Icon(
        Icons.check_rounded,
        size: 18,
        color: context.colorScheme.onPrimary,
      ).center();
    }

    if (stage == activeStage) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.colorScheme.onPrimary,
        ),
      ).center();
    }

    return SizedBox(
      width: 14,
      height: 14,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
      ),
    ).center();
  }

  Color _iconBackgroundColor(BuildContext context) {
    if (orderStatus == OrderTabStatus.cancelled) {
      return context.errorColor;
    }
    if (orderStatus == OrderTabStatus.completed || stage.index <= activeStage.index) {
      return context.primaryColor;
    }
    return context.greySwatch.shade100;
  }

  String get _label {
    switch (stage) {
      case OrderProgressStage.received:
        return LocaleKeys.orders_card_steps_received;
      case OrderProgressStage.processing:
        return LocaleKeys.orders_details_status_processing_title;
      case OrderProgressStage.transit:
        return LocaleKeys.orders_details_status_transit_title;
      case OrderProgressStage.delivered:
        return LocaleKeys.orders_details_status_delivered_title;
    }
  }
}
