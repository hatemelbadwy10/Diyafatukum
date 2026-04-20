import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../data/model/navigation_bar_items.dart';

class CustomBottomNavigationBarItem extends StatelessWidget {
  const CustomBottomNavigationBarItem({super.key, required this.item});
  final NavigationBarItems item;

  @override
  Widget build(BuildContext context) {
    final isActive = item == bottomNavNotifier.value;
    final activeStyle = context.bottomNavBarSelectedLabelStyle;
    if (isActive) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          item.selectedIcon.svg(width: 24, height: 24, colorFilter: context.iconSelectedColor.colorFilter),
          10.gap,
          Text(
            item.label.tr(),
            maxLines: 1,
            style: activeStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ).paddingSymmetric(20, 14).setContainerToView(
        radius: 100,
        color: context.primarySwatch.shade50,
      );
    }

    return item.unselectedIcon.svg(
      width: 26,
      height: 26,
      colorFilter: context.iconUnselectedColor.colorFilter,
    ).withWidth(34);
  }
}
