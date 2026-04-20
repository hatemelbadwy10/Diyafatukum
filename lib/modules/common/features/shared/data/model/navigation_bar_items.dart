import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../core/config/flavor/flavor_config.dart';
import '../../../../../../core/config/router/app_route.dart';
import '../../../../../../core/config/theme/light_theme.dart';

final ValueNotifier<NavigationBarItems> bottomNavNotifier = ValueNotifier<NavigationBarItems>(NavigationBarItems.home);

enum NavigationBarItems {
  home,
  auctions,
  stores,
  more;

  static const List<NavigationBarItems> displayItems = [
    NavigationBarItems.home,
    NavigationBarItems.stores,
    NavigationBarItems.auctions,
    NavigationBarItems.more,
  ];

  SvgGenImage get unselectedIcon {
    if (FlavorConfig.isProvider) {
      switch (this) {
        case NavigationBarItems.home:
          return Assets.icons.solarHome2Broken;
        case NavigationBarItems.auctions:
          return Assets.icons.iconParkOutlineTransactionOrder;
        case NavigationBarItems.stores:
          return Assets.icons.stashShopSolid;
        case NavigationBarItems.more:
          return Assets.icons.solarSettingsBroken;
      }
    }
    switch (this) {
      case NavigationBarItems.home:
        return Assets.icons.solarHome2Broken;
      case NavigationBarItems.auctions:
        return Assets.icons.iconParkOutlineTransactionOrder;
      case NavigationBarItems.stores:
        return Assets.icons.solarCartCheckBroken;
      case NavigationBarItems.more:
        return Assets.icons.solarSettingsBroken;
    }
  }

  SvgGenImage get selectedIcon {
    if (FlavorConfig.isProvider) {
      switch (this) {
        case NavigationBarItems.home:
          return Assets.icons.solarHome2Broken;
        case NavigationBarItems.auctions:
          return Assets.icons.iconParkOutlineTransactionOrder;
        case NavigationBarItems.stores:
          return Assets.icons.stashShopSolid;
        case NavigationBarItems.more:
          return Assets.icons.solarSettingsBroken;
      }
    }
    switch (this) {
      case NavigationBarItems.home:
        return Assets.icons.solarHome2Broken;
      case NavigationBarItems.auctions:
        return Assets.icons.iconParkOutlineTransactionOrder;
      case NavigationBarItems.stores:
        return Assets.icons.solarCartCheckBroken;
      case NavigationBarItems.more:
        return Assets.icons.solarSettingsBroken;
    }
  }

  String get label {
    if (FlavorConfig.isProvider) {
      switch (this) {
        case NavigationBarItems.home:
          return LocaleKeys.provider_home_nav_home;
        case NavigationBarItems.auctions:
          return LocaleKeys.orders_title;
        case NavigationBarItems.stores:
          return LocaleKeys.provider_home_nav_store;
        case NavigationBarItems.more:
          return LocaleKeys.settings_title;
      }
    }
    switch (this) {
      case NavigationBarItems.home:
        return LocaleKeys.home_title;
      case NavigationBarItems.auctions:
        return LocaleKeys.orders_title;
      case NavigationBarItems.stores:
        return LocaleKeys.bag_title;
      case NavigationBarItems.more:
        return LocaleKeys.settings_title;
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
    if (FlavorConfig.isProvider) {
      switch (this) {
        case NavigationBarItems.home:
          bottomNavNotifier.value = NavigationBarItems.home;
          AppRoutes.home.go();
          break;
        case NavigationBarItems.auctions:
          bottomNavNotifier.value = NavigationBarItems.auctions;
          AppRoutes.orders.go();
          break;
        case NavigationBarItems.stores:
          bottomNavNotifier.value = NavigationBarItems.stores;
          AppRoutes.store.go();
          break;
        case NavigationBarItems.more:
          bottomNavNotifier.value = NavigationBarItems.more;
          AppRoutes.settings.go();
          break;
      }
      return;
    }
    switch (this) {
      case NavigationBarItems.home:
        bottomNavNotifier.value = NavigationBarItems.home;
        AppRoutes.home.go();
        break;
      case NavigationBarItems.auctions:
        bottomNavNotifier.value = NavigationBarItems.auctions;
        AppRoutes.orders.go();
        break;
      case NavigationBarItems.stores:
        bottomNavNotifier.value = NavigationBarItems.stores;
        AppRoutes.bag.go();
        break;
      case NavigationBarItems.more:
        bottomNavNotifier.value = NavigationBarItems.more;
        AppRoutes.settings.go();
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
