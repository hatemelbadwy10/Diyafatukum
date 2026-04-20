import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/single_service_model.dart';

class SingleServiceProductCard extends StatelessWidget {
  const SingleServiceProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final SingleServiceProductModel product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.92,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: 24.borderRadius,
              image: DecorationImage(
                image: AssetImage(product.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ).setContainerToView(
            borderWidth: 4,
            borderColor: context.greySwatch.shade100,
            radius: 24,
          ),
        ),
        10.gap,
        Text(
          product.categoryKey.tr(),
          style: context.bodySmall.regular.s12,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        2.gap,
        Text(
          product.name,
          style: context.titleMedium.medium.s18,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        6.gap,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.icons.locationPinDisabled.path.toSvg(
              width: 14,
              height: 14,
              color: context.bodyMedium.color,
            ),
            4.gap,
            Text(
              product.locationKey.tr(),
              style: context.bodyMedium.regular.s14,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ).onTap(onTap, borderRadius: 24.borderRadius);
  }
}
