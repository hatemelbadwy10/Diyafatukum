import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../data/model/order_model.dart';
import 'order_timeline_status_style.dart';

class OrdersProgressStep extends StatelessWidget {
  const OrdersProgressStep({super.key, required this.step});

  final OrderTimelineStep step;

  @override
  Widget build(BuildContext context) {
    final isActive = step.completed || step.current;
    final statusColor = step.status.color(context);

    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: step.current
                ? statusColor
                : isActive
                ? step.status.softColor(context)
                : context.greySwatch.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? statusColor : context.greySwatch.shade300,
            ),
          ),
          child: _buildIcon(context, isActive: isActive),
        ),
        10.gap,
        Text(
          step.status.titleKey.tr(),
          style: context.bodySmall.medium.setColor(
            step.status.textColor(context, isActive: isActive),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ).expand();
  }

  Widget _buildIcon(BuildContext context, {required bool isActive}) {
    if (step.status == OrderTimelineStatus.cancelled ||
        step.status == OrderTimelineStatus.rejected) {
      return Icon(
        step.status.icon,
        size: 17,
        color: step.current
            ? context.colorScheme.onPrimary
            : step.status.color(context),
      ).center();
    }

    if (isActive) {
      return Icon(
        Icons.check_rounded,
        size: 17,
        color: step.current
            ? context.colorScheme.onPrimary
            : step.status.color(context),
      ).center();
    }

    return SizedBox(
      width: 14,
      height: 14,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.greySwatch.shade400,
          shape: BoxShape.circle,
        ),
      ),
    ).center();
  }
}
