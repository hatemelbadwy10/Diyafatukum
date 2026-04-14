import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../resources/gen/locale_keys.g.dart';

class AnimatedPriceRow extends StatelessWidget {
  const AnimatedPriceRow({
    super.key,
    required this.price,
    this.priceAfterDiscount,
    this.priceStyle,
    this.priceAfterDiscountStyle,
  });

  final num price;
  final num? priceAfterDiscount;
  final TextStyle? priceStyle;
  final TextStyle? priceAfterDiscountStyle;

  @override
  Widget build(BuildContext context) {
    if (priceAfterDiscount == 0) {
      return Text(price.toDouble().formattedPrice(), style: priceAfterDiscountStyle ?? context.bodyLarge.s14.bold);
    } else {
      return Row(
        spacing: 4,
        children: [
          if (priceAfterDiscount != null)
            Text(price.toDouble().toStringAsFixed(2), style: priceStyle ?? context.bodyLarge.s12.regular.lineThrough),
          AnimatedFlipCounter(
            fractionDigits: 2,
            hideLeadingZeroes: true,
            thousandSeparator: ',',
            prefix: context.isRTL ? "${LocaleKeys.currency_egp.tr()} " : '',
            suffix: context.isRTL ? '' : " ${LocaleKeys.currency_egp.tr()}",
            textStyle: priceAfterDiscountStyle ?? context.bodyLarge.s14.bold,
            value: priceAfterDiscount != null ? priceAfterDiscount! : price,
          ),
        ],
      );
    }
  }
}
