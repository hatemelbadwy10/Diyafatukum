import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';
import 'order_timeline_status_style.dart';

class ProviderOrderStatusCard extends StatelessWidget {
  const ProviderOrderStatusCard({super.key, required this.step});

  final OrderTimelineStep step;

  @override
  Widget build(BuildContext context) {
    final isActive = step.completed || step.current;
    final isCurrent = step.current;
    final statusColor = step.status.color(context);

    return Container(
      width: double.infinity,
      padding: 20.edgeInsetsAll,
      decoration: BoxDecoration(
        color: isCurrent
            ? statusColor
            : isActive
            ? step.status.softColor(context)
            : context.greySwatch.shade100,
        borderRadius: 18.borderRadius,
        border: Border.all(
          color: isActive ? statusColor : context.greySwatch.shade300,
        ),
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: Row(
        children: [
          _LeadingBadge(isActive: isActive, status: step.status),
          20.gap,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.status.titleKey.tr(),
                style: context.displaySmall.bold.s18.setColor(
                  isCurrent
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurface,
                ),
              ),
              if (isCurrent) ...[
                8.gap,
                Text(
                  step.status.subtitleKey.tr(),
                  style: context.bodyMedium.regular.setColor(
                    context.colorScheme.onPrimary.withValues(alpha: 0.92),
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
                  ? statusColor.withValues(alpha: isCurrent ? 0.22 : 0.12)
                  : context.scaffoldBackgroundColor,
              borderRadius: 14.borderRadius,
            ),
            child: Icon(
              step.status.icon,
              size: 28,
              color: isCurrent
                  ? context.colorScheme.onPrimary
                  : step.status.textColor(context, isActive: isActive),
            ).center(),
          ),
        ],
      ),
    );
  }
}

class _LeadingBadge extends StatelessWidget {
  const _LeadingBadge({required this.isActive, required this.status});

  final bool isActive;
  final OrderTimelineStatus status;

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
        color: isActive ? status.color(context) : context.greySwatch.shade400,
      ).center(),
    );
  }
}
