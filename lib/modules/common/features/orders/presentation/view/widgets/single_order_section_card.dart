import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class SingleOrderSectionCard extends StatelessWidget {
  const SingleOrderSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.titleMedium.semiBold.s16.setColor(
            context.colorScheme.onSurface,
          ),
        ),
        20.gap,
        Container(
          width: double.infinity,
          padding: 20.edgeInsetsAll,
          decoration: BoxDecoration(
            color: context.scaffoldBackgroundColor,
            borderRadius: 24.borderRadius,
            boxShadow: ShadowStyles.bottomSheetShadow,
          ),
          child: Column(
            children: [
              for (int index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) 28.gap,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
