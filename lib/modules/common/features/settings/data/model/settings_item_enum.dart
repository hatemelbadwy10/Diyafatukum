import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../core/config/router/route_manager.dart';
import '../../../../../../core/config/theme/light_theme.dart';
import 'base_menu_item_model.dart';

enum SettingsItem implements BaseMenuItem {
  changePassword,
  notification,
  language;

  @override
  String get title {
    switch (this) {
      case SettingsItem.language:
        return LocaleKeys.settings_language_title.tr();
      case SettingsItem.changePassword:
        return LocaleKeys.auth_password_change.tr();

      case SettingsItem.notification:
        return LocaleKeys.notifications_title.tr();
    }
  }

  @override
  SvgGenImage get icon {
    switch (this) {
      case SettingsItem.language:
        return Assets.icons.materialSymbolsLightLanguage;

      case SettingsItem.changePassword:
        return Assets.icons.eyeOutlined;

      case SettingsItem.notification:
        return Assets.icons.cuidaNotificationBellOutline;
    }
  }

  @override
  AssetGenImage? get image {
    return null;
  }

  @override
  BaseRoute? get route {
    return null;
  }

  @override
  Object? get arguments {
    return null;
  }

  @override
  Color? get iconBackgroundColor {
    switch (this) {
      default:
        return LightThemeColors.secondaryContainer;
    }
  }

  @override
  Color? get iconColor {
    switch (this) {
      default:
        return LightThemeColors.onBackgroundIcon;
    }
  }

  @override
  bool get needAuthorization {
    switch (this) {
      case SettingsItem.changePassword:
        return true;
      case SettingsItem.notification:
        return true;
      case SettingsItem.language:
        return false;
    }
  }

  @override
  bool get isDestructive => false;

  static List<SettingsItem> items(bool isAuthorized) {
    return SettingsItem.values.where((item) => item.needAuthorization ? isAuthorized : true).toList();
  }
}
