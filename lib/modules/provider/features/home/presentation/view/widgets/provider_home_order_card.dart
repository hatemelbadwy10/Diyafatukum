import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../data/model/provider_home_model.dart';

class ProviderHomeOrderCard extends StatelessWidget {
  const ProviderHomeOrderCard({
    super.key,
    required this.order,
    required this.onAccept,
    required this.onReject,
  });

  final ProviderHomeOrderModel order;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final isPending = order.status == ProviderHomeOrderStatus.pending;

    return Container(
      padding: 18.edgeInsetsAll,
      decoration: BoxDecoration(
        color: context.scaffoldBackgroundColor,
        borderRadius: 18.borderRadius,
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.85)),
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                LocaleKeys.orders_card_code.tr(),
                style: context.titleMedium.medium,
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
            children: [
              Assets.icons.solarUserBold
                  .svg(
                    width: 28,
                    height: 28,
                    colorFilter: context.primaryColor.colorFilter,
                  )
                  .setContainerToView(
                    color: context.primarySwatch.shade50,
                    radius: 12,
                    padding: 8,
                  ),
              12.gap,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerName,
                    style: context.titleMedium.medium,
                    textAlign: TextAlign.end,
                  ),
                  6.gap,
                  Text(
                    order.dateLabel,
                    style: context.titleSmall.regular.setColor(
                      context.greySwatch.shade600,
                    ),
                  ),
                ],
              ),
              12.gap,

              Spacer(),
              _OrderStatusPill(status: order.status),
            ],
          ),
          if (isPending) ...[
            22.gap,
            Row(
              children: [
                CustomButton.gradient(
                  borderRadius: 12,
                  label: LocaleKeys.provider_home_card_accept.tr(),
                  onPressed: () {
                    onAccept();
                    Toaster.showToast(
                      LocaleKeys.provider_home_messages_accepted.tr(),
                      isError: false,
                    );
                  },
                ).expand(),
                16.gap,

                CustomButton.outlined(
                  backgroundColor: Colors.transparent,
                  borderColor: context.errorColor,
                  borderRadius: 12,
                  textStyle: context.titleMedium.bold.setColor(
                    context.errorColor,
                  ),
                  label: LocaleKeys.provider_home_card_reject.tr(),
                  onPressed: () {
                    onReject();
                    Toaster.showToast(
                      LocaleKeys.provider_home_messages_rejected.tr(),
                      isError: false,
                    );
                  },
                ).expand(),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderStatusPill extends StatelessWidget {
  const _OrderStatusPill({required this.status});

  final ProviderHomeOrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Text(
          _label.tr(),
          style: context.titleMedium.medium.setColor(_foreground(context)),
        )
        .paddingSymmetric(28, 14)
        .setContainerToView(color: _background(context), radius: 999);
  }

  String get _label {
    switch (status) {
      case ProviderHomeOrderStatus.accepted:
        return LocaleKeys.provider_home_card_status_accepted;
      case ProviderHomeOrderStatus.rejected:
        return LocaleKeys.provider_home_card_status_rejected;
      case ProviderHomeOrderStatus.pending:
        return LocaleKeys.provider_home_card_status_pending;
    }
  }

  Color _background(BuildContext context) {
    switch (status) {
      case ProviderHomeOrderStatus.accepted:
        return context.successColor.withValues(alpha: 0.14);
      case ProviderHomeOrderStatus.rejected:
        return context.errorColor.withValues(alpha: 0.12);
      case ProviderHomeOrderStatus.pending:
        return const Color(0xFFC8A473);
    }
  }

  Color _foreground(BuildContext context) {
    switch (status) {
      case ProviderHomeOrderStatus.accepted:
        return context.successColor;
      case ProviderHomeOrderStatus.rejected:
        return context.errorColor;
      case ProviderHomeOrderStatus.pending:
        return context.scaffoldBackgroundColor;
    }
  }
}
