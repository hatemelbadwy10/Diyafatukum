import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/gen/locale_keys.g.dart';
import '../../../data/model/single_service_store_model.dart';
import 'single_service_store_item_action.dart';

class SingleServiceStoreItemCard extends StatelessWidget {
  const SingleServiceStoreItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onSelect,
    required this.onIncrement,
    required this.onDecrement,
  });

  final SingleServiceStoreItemModel item;
  final int quantity;
  final VoidCallback onSelect;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
              Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                borderRadius: 18.borderRadius,
                image: DecorationImage(
                  image: AssetImage(item.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          
            14.gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: context.titleMedium.medium.s20,
                  textAlign: TextAlign.right,
                ),
                6.gap,
                Text(
                  '${item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 2)} ${LocaleKeys.currency_sar.tr()}',
                  style: context.titleSmall.medium.s18.setColor(
                    context.primaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ).expand(),
            14.gap,
            SingleServiceStoreItemAction(
              quantity: quantity,
              onSelect: onSelect,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
          ],
        ),
        18.gap,
        Divider(height: 1, color: context.greySwatch.shade100),
      ],
    );
  }
}
