import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({
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
        children: [
          Text(
            priceAfterDiscount != null
                ? priceAfterDiscount!.toDouble().formattedPrice()
                : price.toDouble().formattedPrice(),
            style: priceAfterDiscountStyle ?? context.bodyLarge.s14.bold,
          ),
          4.gap,
          if (priceAfterDiscount != null)
            Text(
              price.toDouble().formattedPrice(),
              style: priceStyle ?? context.bodyLarge.s12.regular.lineThrough,
            ),
        ],
      );
    }
  }
}
