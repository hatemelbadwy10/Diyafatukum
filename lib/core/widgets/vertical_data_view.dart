import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';

class VerticalDataView extends StatelessWidget {
  const VerticalDataView({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.gap = 4.0,
  });
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle ?? context.bodyMedium.s14.regular),
        gap.gap,
        Text(subtitle, style: subtitleStyle ?? context.bodyLarge.s14.medium, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
