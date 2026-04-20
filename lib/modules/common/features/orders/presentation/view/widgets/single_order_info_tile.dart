import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';

class SingleOrderInfoTile extends StatelessWidget {
  const SingleOrderInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final Widget icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.08),
            borderRadius: 16.borderRadius,
          ),
          child: icon.center(),
        ),
        16.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.titleSmall.regular.setColor(
                context.greySwatch.shade600,
              ),
            ),
            8.gap,
            Text(
              value,
              style: context.titleMedium.bold.setColor(
                context.colorScheme.onSurface,
              ),
            ),
          ],
        ).expand(),
      ],
    );
  }
}
