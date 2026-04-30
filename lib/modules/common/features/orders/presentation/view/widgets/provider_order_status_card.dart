import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';

class ProviderOrderStatusCard extends StatelessWidget {
  const ProviderOrderStatusCard({
    super.key,
    required this.stage,
    required this.activeStage,
  });

  final OrderProgressStage stage;
  final OrderProgressStage activeStage;

  @override
  Widget build(BuildContext context) {
    final isActive = stage.index <= activeStage.index;
    final isCurrent = stage == activeStage;

    return Container(
      width: double.infinity,
      padding: 20.edgeInsetsAll,
      decoration: BoxDecoration(
        color: isActive ? context.primaryColor.withValues(alpha: isCurrent ? 0.96 : 0.18) : context.greySwatch.shade100,
        borderRadius: 18.borderRadius,
        border: Border.all(
          color: isActive ? context.primaryColor : context.greySwatch.shade300,
        ),
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: Row(
        children: [
          _LeadingBadge(isActive: isActive),
          20.gap,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _label.tr(),
                style: context.displaySmall.bold.s18.setColor(
                  isActive ? context.colorScheme.onPrimary : context.colorScheme.onSurface,
                ),
              ),
              if (isCurrent && activeStage != OrderProgressStage.delivered) ...[
                8.gap,
                Text(
                  LocaleKeys.provider_home_orders_next_step_hint.tr(),
                  style: context.bodyMedium.regular.setColor(
                    isActive
                        ? context.colorScheme.onPrimary.withValues(alpha: 0.92)
                        : context.greySwatch.shade600,
                  ),
                ),
              ],
            ],
          ).expand(),
          16.gap,
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive
                  ? context.primaryColor.withValues(alpha: 0.14)
                  : context.scaffoldBackgroundColor,
              borderRadius: 14.borderRadius,
            ),
            child: Icon(
              _icon,
              size: 28,
              color: isActive ? context.colorScheme.onPrimary : context.greySwatch.shade500,
            ).center(),
          ),
        ],
      ),
    );
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

  IconData get _icon {
    switch (stage) {
      case OrderProgressStage.received:
        return Icons.check_circle_outline_rounded;
      case OrderProgressStage.processing:
        return Icons.inventory_2_outlined;
      case OrderProgressStage.transit:
        return Icons.local_shipping_outlined;
      case OrderProgressStage.delivered:
        return Icons.verified_outlined;
    }
  }
}

class _LeadingBadge extends StatelessWidget {
  const _LeadingBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check_rounded,
        size: 20,
        color: isActive ? context.primaryColor : context.greySwatch.shade400,
      ).center(),
    );
  }
}
