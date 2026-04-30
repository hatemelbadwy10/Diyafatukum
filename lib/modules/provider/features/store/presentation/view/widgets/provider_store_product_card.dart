import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../data/model/provider_store_model.dart';

class ProviderStoreProductCard extends StatelessWidget {
  const ProviderStoreProductCard({
    super.key,
    required this.product,
    required this.onDeleteTap,
    required this.onEditTap,
  });

  final ProviderStoreProductModel product;
  final VoidCallback onDeleteTap;
  final VoidCallback onEditTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Assets.icons.deleteIcon.svg(
                  width: 20,
                  height: 20,
                  colorFilter: context.errorColor.colorFilter,
                ).onTap(onDeleteTap),
                20.gap,
                Assets.icons.tablerEdit.svg(
                  width: 20,
                  height: 20,
                  colorFilter: context.primaryColor.colorFilter,
                ).onTap(onEditTap),
              ],
            ),
            16.gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: context.titleMedium.medium.s20,
                ),
                8.gap,
                Text(
                  '${product.price.toStringAsFixed(product.price.truncateToDouble() == product.price ? 0 : 2)} ${LocaleKeys.currency_sar.tr()}',
                  style: context.titleSmall.medium.s18.setColor(context.primaryColor),
                ),
              ],
            ).expand(),
            14.gap,
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: 18.borderRadius,
                image: DecorationImage(
                  image: AssetImage(product.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: const SizedBox(width: 92, height: 92),
            ),
          ],
        ),
        18.gap,
        Divider(height: 1, color: context.greySwatch.shade100),
      ],
    );
  }
}
