import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_image.dart';
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
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomImage.rounded(
              height: double.infinity,
              imageUrl: product.imagePath,
              radius: 24,
            ),
          ).setContainerToView(
            borderWidth: 4,
            borderColor: context.greySwatch.shade100,
            radius: 24,
          ),
        ),
        10.gap,
        Text(
          product.categoryKey,
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
              product.locationKey,
              style: context.bodyMedium.regular.s14,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    ).onTap(onTap, borderRadius: 24.borderRadius);
  }
}
