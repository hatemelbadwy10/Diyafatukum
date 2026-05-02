import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_image.dart';
import '../../../data/model/bag_model.dart';
import 'bag_quantity_control.dart';

class BagItemCard extends StatelessWidget {
  const BagItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
  });

  final BagItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(borderRadius: 20.borderRadius),
              clipBehavior: Clip.antiAlias,
              child: _buildImage(context),
            ),
            16.gap,
            Container(
              constraints: BoxConstraints(
                minHeight: 96,
                maxWidth: context.width * 0.48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: context.titleLarge.medium.s20,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  10.gap,
                  Text(
                    '${item.totalPrice.toStringAsFixed(0)} ${LocaleKeys.currency_sar.tr()}',
                    style: context.titleLarge.bold.s18.setColor(
                      context.primaryColor,
                    ),
                  ),
                ],
              ),
            ).expand(),
             BagQuantityControl(
              quantity: item.quantity,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ],
        )
        .paddingAll(16)
        .setContainerToView(
          height: 128,
          radius: 24,
          borderColor: context.primaryColor.withValues(alpha: 0.24),
          color: context.scaffoldBackgroundColor,
        );
  }

  Widget _buildImage(BuildContext context) {
    if (item.imagePath.startsWith('http')) {
      return CustomImage.square(
        imageUrl: item.imagePath,
        size: 96,
        borderRadius: 20.borderRadius,
      );
    }

    if (item.imagePath.isNotEmpty) {
      return Image.asset(item.imagePath, fit: BoxFit.cover);
    }

    return Container(
      color: context.greySwatch.shade100,
      child: Assets.icons.boxiconsCamera
          .svg(colorFilter: context.greySwatch.shade400.colorFilter)
          .paddingAll(24)
          .center(),
    );
  }
}
