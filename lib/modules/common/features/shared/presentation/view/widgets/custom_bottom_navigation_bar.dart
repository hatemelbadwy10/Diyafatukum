
import 'package:deals/core/config/extensions/all_extensions.dart';
import 'package:flutter/material.dart';


import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/navigation_bar_items.dart';
import 'custom_bottom_navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.onTap});
  final void Function(NavigationBarItems item) onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 200.milliseconds,
      curve: Curves.easeInOutCubicEmphasized,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        color: context.surfaceColor,
        boxShadow: ShadowStyles.bottomSheetShadow,
      ),
      child: ValueListenableBuilder(
        valueListenable: bottomNavNotifier,
        builder: (context, value, _) {
          final items = NavigationBarItems.displayItems;
          return BottomAppBar(
            padding: 16.edgeInsetsHorizontal + 12.edgeInsetsVertical,
            height: kBottomNavigationBarHeight + 16,
            color: context.scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  items.map((item) {
                    return CustomBottomNavigationBarItem(item: item).onTap(
                      () => onTap.call(item),
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    );
                  }).toList(),
            ),
          );
        },
      ).clipRRectTop(30),
    );
  }
}
