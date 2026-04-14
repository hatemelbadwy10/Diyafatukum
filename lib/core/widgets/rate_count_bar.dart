import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class RateCountBar extends StatelessWidget {
  const RateCountBar({
    super.key,
    this.style,
    this.rateCount,
    required this.rate,
  });
  final TextStyle? style;
  final int? rateCount;
  final num rate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Assets.icons.starFill.svg(width: 12, colorFilter: context.warningColor.colorFilter).paddingBottom(2),
        4.gap,
        Text(rate.toStringAsFixed(1), style: style ?? context.bodyMedium.s12.regular),
        if (rateCount != null) ...[
          4.gap,
          Text("($rateCount)", style: style ?? context.bodyMedium.s12.regular),
        ],
      ],
    );
  }
}
