import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';
import 'order_timeline_status_style.dart';

class ProviderOrderStatusCard extends StatelessWidget {
  const ProviderOrderStatusCard({
    super.key,
    required this.step,
    this.cancellationReason = '',
  });

  final OrderTimelineStep step;
  final String cancellationReason;

  @override
  Widget build(BuildContext context) {
    final isActive = step.completed || step.current;
    final isCurrent = step.current;
    final statusColor = step.status.color(context);
    final showCancellationReason =
        (step.status == OrderTimelineStatus.cancelled ||
            step.status == OrderTimelineStatus.rejected) &&
        cancellationReason.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: 20.edgeInsetsAll,
      decoration: BoxDecoration(
        color: isCurrent ? statusColor : step.status.softColor(context),
        borderRadius: 18.borderRadius,
        border: Border.all(
          color: statusColor.withValues(alpha: isCurrent ? 1 : 0.35),
        ),
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LeadingBadge(isActive: isActive, status: step.status),
              20.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.status.titleKey.tr(),
                    style: context.displaySmall.bold.s18.setColor(
                      isCurrent ? context.colorScheme.onPrimary : statusColor,
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
                  ] else ...[
                    8.gap,
                    Text(
                      step.status.subtitleKey.tr(),
                      style: context.bodyMedium.regular.setColor(
                        statusColor.withValues(alpha: 0.8),
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
                  color: isCurrent
                      ? context.colorScheme.onPrimary.withValues(alpha: 0.18)
                      : statusColor.withValues(alpha: 0.12),
                  borderRadius: 14.borderRadius,
                ),
                child: Icon(
                  step.status.icon,
                  size: 28,
                  color: isCurrent
                      ? context.colorScheme.onPrimary
                      : statusColor,
                ).center(),
              ),
            ],
          ),
          if (showCancellationReason) ...[
            14.gap,
            Container(
              width: double.infinity,
              padding: 14.edgeInsetsAll,
              decoration: BoxDecoration(
                color: isCurrent
                    ? context.colorScheme.onPrimary.withValues(alpha: 0.14)
                    : statusColor.withValues(alpha: 0.08),
                borderRadius: 12.borderRadius,
                border: Border.all(
                  color: statusColor.withValues(alpha: isCurrent ? 0.0 : 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.orders_details_status_cancelled_reason_label
                        .tr(),
                    style: context.bodySmall.semiBold.setColor(
                      isCurrent
                          ? context.colorScheme.onPrimary.withValues(alpha: 0.9)
                          : statusColor,
                    ),
                  ),
                  6.gap,
                  Text(
                    cancellationReason,
                    style: context.bodyMedium.regular.setColor(
                      isCurrent
                          ? context.colorScheme.onPrimary
                          : statusColor.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        color: isActive ? status.color(context) : status.color(context),
      ).center(),
    );
  }
}
