import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';
import '../../../data/model/bag_model.dart';

class BagSummarySection extends StatelessWidget {
  const BagSummarySection({
    super.key,
    required this.bag,
    required this.onCheckout,
  });

  final BagModel bag;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BagSummaryRow(
          label: LocaleKeys.printing_actions_print_price_title.tr(),
          value:
              '${bag.subtotal.toStringAsFixed(0)} ${LocaleKeys.currency_sar.tr()}',
        ),
        20.gap,
        _BagSummaryRow(
          label: LocaleKeys.coupons_details_discount_title.tr(),
          value:
              '- ${bag.discount.toStringAsFixed(0)} ${LocaleKeys.currency_sar.tr()}',
        ),
        Divider(height: 40, color: context.greySwatch.shade300),
        _BagSummaryRow(
          label: LocaleKeys.orders_details_summary_total.tr(),
          value:
              '${bag.total.toStringAsFixed(0)} ${LocaleKeys.currency_sar.tr()}',
          isHighlighted: true,
        ),
        24.gap,
        CustomButton(
          label: LocaleKeys.bag_actions_checkout.tr(),
          onPressed: onCheckout,
        ),
      ],
    ).paddingHorizontal(AppSize.screenPadding).paddingBottom(16);
  }
}

class _BagSummaryRow extends StatelessWidget {
  const _BagSummaryRow({
    required this.label,
    required this.value,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final valueStyle = isHighlighted
        ? context.titleLarge.bold.s22.setColor(context.primaryColor)
        : context.titleMedium.medium.s18;

    return Row(
      children: [
        Text(label, style: context.titleMedium.medium.s18),

        const Spacer(),
        Text(value, style: valueStyle),
      ],
    );
  }
}
