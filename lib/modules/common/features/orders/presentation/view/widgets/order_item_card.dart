import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_image.dart';
import '../../../data/model/order_model.dart';
import 'order_timeline_status_style.dart';
import 'orders_progress_step.dart';
import 'orders_status_badge.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 18.edgeInsetsAll,
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: 20.borderRadius,
        border: Border.all(color: _borderColor(context)),
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                LocaleKeys.orders_card_code.tr(),
                style: context.titleMedium.medium.setColor(
                  context.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                order.id,
                style: context.titleMedium.medium.setColor(
                  context.greySwatch.shade600,
                ),
              ),
            ],
          ),
          18.gap,
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: 12.borderRadius,
                child: _buildStoreImage(context),
              ),
              12.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.storeName, style: context.titleMedium.medium),
                  8.gap,
                  Text(
                    order.dateLabel,
                    style: context.titleSmall.regular.setColor(
                      context.greySwatch.shade600,
                    ),
                  ),
                ],
              ).expand(),
              12.gap,

              OrdersStatusBadge(status: order.activeStatus),
            ],
          ),
          24.gap,
          Row(
            children: order.timeline
                .map((step) => OrdersProgressStep(step: step))
                .toList(),
          ),
        ],
      ),
    ).onTap(
      () => AppRoutes.orderDetails.push(extra: order),
      borderRadius: 20.borderRadius,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  Color _borderColor(BuildContext context) {
    switch (order.tabStatus) {
      case OrderTabStatus.completed:
        return order.activeStatus.color(context).withValues(alpha: 0.35);
      case OrderTabStatus.cancelled:
        return order.activeStatus.color(context).withValues(alpha: 0.28);
      case OrderTabStatus.current:
        return order.activeStatus.color(context).withValues(alpha: 0.9);
    }
  }

  Widget _buildStoreImage(BuildContext context) {
    final imagePath = order.storeImagePath.trim();
    if (imagePath.startsWith('http')) {
      return CustomImage(height: 84, width: 84, imageUrl: imagePath);
    }

    if (imagePath.isNotEmpty) {
      return Image.asset(imagePath, width: 84, height: 84, fit: BoxFit.cover);
    }

    return Container(
      width: 84,
      height: 84,
      color: context.greySwatch.shade100,
      child: Assets.icons.boxiconsCamera
          .svg(colorFilter: context.greySwatch.shade400.colorFilter)
          .paddingAll(20)
          .center(),
    );
  }
}
