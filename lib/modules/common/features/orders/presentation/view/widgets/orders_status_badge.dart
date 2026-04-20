import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';

class OrdersStatusBadge extends StatelessWidget {
  const OrdersStatusBadge({
    super.key,
    required this.status,
  });

  final OrderTabStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.edgeInsetsHorizontal + 12.edgeInsetsVertical,
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: 20.borderRadius,
      ),
      child: Text(
        _label.tr(),
        style: context.titleMedium.medium.setColor(context.colorScheme.onPrimary),
      ),
    );
  }

  String get _label {
    switch (status) {
      case OrderTabStatus.completed:
        return LocaleKeys.orders_card_badge_completed;
      case OrderTabStatus.cancelled:
        return LocaleKeys.orders_card_badge_cancelled;
      case OrderTabStatus.current:
        return LocaleKeys.orders_card_badge_received;
    }
  }

  Color _backgroundColor(BuildContext context) {
    switch (status) {
      case OrderTabStatus.completed:
        return context.successColor;
      case OrderTabStatus.cancelled:
        return context.errorColor;
      case OrderTabStatus.current:
        return context.primaryColor;
    }
  }
}
