import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../data/model/order_model.dart';
import 'order_timeline_status_style.dart';

class OrdersStatusBadge extends StatelessWidget {
  const OrdersStatusBadge({super.key, required this.status});

  final OrderTimelineStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.edgeInsetsHorizontal + 12.edgeInsetsVertical,
      decoration: BoxDecoration(
        color: _backgroundColor(context),
        borderRadius: 20.borderRadius,
      ),
      child: Text(
        status.titleKey.tr(),
        style: context.titleMedium.medium.setColor(
          context.colorScheme.onPrimary,
        ),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    return status.color(context);
  }
}
