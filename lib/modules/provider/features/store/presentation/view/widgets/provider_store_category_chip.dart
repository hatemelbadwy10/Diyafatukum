import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';

class ProviderStoreCategoryChip extends StatelessWidget {
  const ProviderStoreCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Text(
          label,
          style: context.bodyMedium.medium.s14.setColor(
            isSelected ? context.primaryColor : context.greySwatch.shade500,
          ),
        )
        .paddingSymmetric(18, 10)
        .setContainerToView(
          radius: 10,
          color: isSelected ? context.primaryColor.withValues(alpha: 0.12) : context.scaffoldBackgroundColor,
          borderColor: isSelected ? Colors.transparent : context.greySwatch.shade300,
        )
        .onTap(onTap, borderRadius: 10.borderRadius);
  }
}
