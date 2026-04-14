
import 'package:deals/core/config/extensions/all_extensions.dart';
import 'package:flutter/material.dart';


import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/navigation_bar_items.dart';
import 'custom_bottom_navigation_bar_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key, required this.onTap});
  final void Function(int) onTap;

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
          return BottomAppBar(
            padding: 0.edgeInsetsAll,
            height: kBottomNavigationBarHeight,
            color: context.scaffoldBackgroundColor,
            child: Stack(
              children: [
                AnimatedPositionedDirectional(
                  top: 0,
                  duration: 200.milliseconds,
                  curve: Curves.easeInOutCubicEmphasized,
                  start: ((context.width / NavigationBarItems.items.length) * value.index) + 30,
                  child: Container(
                    height: 4,
                    width: context.width / NavigationBarItems.values.length - 60,
                    decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      NavigationBarItems.values.map((item) {
                        return CustomBottomNavigationBarItem(item: item).onTap(
                          () => onTap.call(item.index),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        },
      ).clipRRectTop(30),
    );
  }
}
