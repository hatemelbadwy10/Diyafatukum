import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class SingleServiceStoreBottomBar extends StatelessWidget {
  const SingleServiceStoreBottomBar({
    super.key,
    required this.totalPrice,
    required this.selectedItemsCount,
    required this.onTap,
  });

  final double totalPrice;
  final int selectedItemsCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Row(
        children: [
           Text(
            '$selectedItemsCount',
            style: context.titleSmall.bold.s18.setColor(Colors.white),
          )
              .center()
              .setContainerToView(
                width: 36,
                height: 36,
                radius: 18,
                color: context.scaffoldBackgroundColor.withValues(alpha: 0.2),
              ),
          12.gap,
          Text(
            LocaleKeys.home_user_store_add_to_cart.tr(),
            style: context.titleSmall.bold.s20.setColor(context.onPrimary),
          ).expand(),
          12.gap,
           Text(
            '${totalPrice.toStringAsFixed(2)} ${LocaleKeys.currency_sar.tr()}',
            style: context.titleSmall.bold.s20.setColor(context.onPrimary),
          ),
        
        ],
      )
          .paddingSymmetric(AppSize.screenPadding, 14)
          .setContainerToView(
            color: context.primaryColor,
            radius: 18,
          )
          .onTap(onTap, borderRadius: 18.borderRadius)
          .paddingOnly(
            left: AppSize.screenPadding,
            right: AppSize.screenPadding,
            bottom: 12,
            top: 8,
          ),
    );
  }
}
