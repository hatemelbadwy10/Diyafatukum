import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';

class ProviderStoreAddCategoryChip extends StatelessWidget {
  const ProviderStoreAddCategoryChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.provider_store_categories_add.tr(),
              style: context.bodyMedium.medium.s14.setColor(context.greySwatch.shade400),
            ),
            8.gap,
            Icon(Icons.add_rounded, size: 18, color: context.greySwatch.shade400),
          ],
        )
        .paddingSymmetric(16, 10)
        .withDottedBorder(color: context.greySwatch.shade300, radius: 10)
        .onTap(onTap, borderRadius: 10.borderRadius);
  }
}
