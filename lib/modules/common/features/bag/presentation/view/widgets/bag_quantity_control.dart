import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';

class BagQuantityControl extends StatelessWidget {
  const BagQuantityControl({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '+',
          style: context.displayMedium.medium.s24.setColor(
            context.primaryColor,
          ),
        ).onTap(onIncrement, borderRadius: 12.borderRadius),
        6.gap,
        Text(
          quantity.toString().padLeft(2, '0'),
          style: context.titleLarge.medium.s18,
        ),
        6.gap,
        Text(
          '−',
          style: context.displayMedium.medium.s24.setColor(
            context.greySwatch.shade500,
          ),
        ).onTap(onDecrement, borderRadius: 12.borderRadius),
      ],
    ).withWidth(28);
  }
}
