import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/bag_model.dart';

class BagItemCard extends StatelessWidget {
  const BagItemCard({
    super.key,
    required this.item,
  });

  final BagItemModel item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: 24.borderRadius,
            image: DecorationImage(
              image: AssetImage(item.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        16.gap,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.name}${item.quantity}x ',
              style: context.titleMedium.medium.s20,
            ),
            12.gap,
            Text(
              '${item.totalPrice.toStringAsFixed(0)} ${LocaleKeys.currency_sar.tr()}',
              style: context.titleMedium.bold.s18.setColor(context.primaryColor),
            ),
          ],
        ).expand(),
      ],
    )
        .paddingAll(16)
        .setContainerToView(
          radius: 24,
          borderColor: context.greySwatch.shade100,
          color: context.scaffoldBackgroundColor,
        );
  }
}
