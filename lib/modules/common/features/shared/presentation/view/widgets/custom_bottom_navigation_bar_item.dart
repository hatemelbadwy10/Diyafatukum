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
    final unselectedStyle = context.bottomNavBarUnselectedLabelStyle;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (item == bottomNavNotifier.value)
          item.selectedIcon.svg(width: 24, colorFilter: context.iconSelectedColor.colorFilter)
        else
          item.unselectedIcon.svg(width: 24, colorFilter: context.iconUnselectedColor.colorFilter),
        2.gap,
        Text(
          item.label.tr(),
          maxLines: 2,
          style: isActive ? activeStyle : unselectedStyle,
          textAlign: TextAlign.center,
        ),
      ],
    ).withWidth(context.width / 5);
  }
}
