import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../core/config/router/app_route.dart';
import '../../../../../../core/config/theme/light_theme.dart';

final ValueNotifier<NavigationBarItems> bottomNavNotifier = ValueNotifier<NavigationBarItems>(NavigationBarItems.home);

enum NavigationBarItems {
  home,
  auctions,
  stores,
  more;

  SvgGenImage get unselectedIcon {
    switch (this) {
      case NavigationBarItems.home:
        return Assets.icons.solarHome2Broken;
      case NavigationBarItems.auctions:
        return Assets.icons.mdiCartRemove;
      case NavigationBarItems.stores:
        return Assets.icons.iconParkOutlineTransactionOrder;
      case NavigationBarItems.more:
        return Assets.icons.solarSettingsBroken;
    }
  }

  SvgGenImage get selectedIcon {
    switch (this) {
      case NavigationBarItems.home:
        return Assets.icons.solarHome2Broken;
      case NavigationBarItems.auctions:
        return Assets.icons.mdiCartRemove;
      case NavigationBarItems.stores:
        return Assets.icons.iconParkOutlineTransactionOrder;
      case NavigationBarItems.more:
        return Assets.icons.solarSettingsBroken;
    }
  }

  String get label {
    switch (this) {
      case NavigationBarItems.home:
        return LocaleKeys.home_title;
      case NavigationBarItems.auctions:
        return LocaleKeys.orders_title;
      case NavigationBarItems.stores:
        return LocaleKeys.orders_title;
      case NavigationBarItems.more:
        return LocaleKeys.more_title;
    }
  }

  BottomNavigationBarItem get item {
    return BottomNavigationBarItem(
      label: label.tr(),
      icon: SvgPicture.asset(
        unselectedIcon.path,
        width: 24,
        colorFilter: LightThemeColors.unselectedIcon.colorFilter,
      ).paddingTop(8),
      activeIcon: SvgPicture.asset(
        unselectedIcon.path,
        width: 24,
        colorFilter: LightThemeColors.primary.colorFilter,
      ).paddingTop(8),
    );
  }

  static List<BottomNavigationBarItem> get items {
    return List.generate(NavigationBarItems.values.length, (index) {
      return NavigationBarItems.values[index].item;
    });
  }

  void navigate() {
    switch (this) {
      case NavigationBarItems.home:
        bottomNavNotifier.value = NavigationBarItems.home;
        AppRoutes.home.go();
        break;
      case NavigationBarItems.auctions:
        bottomNavNotifier.value = NavigationBarItems.auctions;
        AppRoutes.auctions.go();
        break;
      case NavigationBarItems.stores:
        bottomNavNotifier.value = NavigationBarItems.stores;
        AppRoutes.bag.go();
        break;
      case NavigationBarItems.more:
        bottomNavNotifier.value = NavigationBarItems.more;
        AppRoutes.moreMenu.go();
        break;
    }
  }

  void onTap(int index, StatefulNavigationShell shell) {
    if (index > 2) {
      shell.goBranch(index - 1);
    } else {
      shell.goBranch(index);
    }
  }
}
