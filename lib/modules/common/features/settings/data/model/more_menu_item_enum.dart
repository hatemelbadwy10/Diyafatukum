import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/config/router/app_route.dart';
import '../../../../../../core/config/router/route_manager.dart';
import '../../../../../../core/config/theme/light_theme.dart';
import 'base_menu_item_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/resources/resources.dart';
import 'static_page_enum.dart';

enum MoreMenuItem implements BaseMenuItem {
  profile,
  wallet,
  addresses,
  coupons,
  settings,
  about,
  privacy,
  terms,
  contact,
  faq,
  logout;

  @override
  String get title {
    switch (this) {
      case MoreMenuItem.profile:
        return LocaleKeys.account_profile_title.tr();
      case MoreMenuItem.wallet:
        return LocaleKeys.wallet_title.tr();
      case MoreMenuItem.addresses:
        return LocaleKeys.addresses_title.tr();
      case MoreMenuItem.coupons:
        return LocaleKeys.coupons_title.tr();
      case MoreMenuItem.settings:
        return LocaleKeys.settings_title.tr();
      case MoreMenuItem.about:
        return LocaleKeys.settings_about.tr();
      case MoreMenuItem.privacy:
        return LocaleKeys.settings_privacy.tr();
      case MoreMenuItem.terms:
        return LocaleKeys.settings_terms.tr();
      case MoreMenuItem.contact:
        return LocaleKeys.settings_contact_title.tr();
      case MoreMenuItem.faq:
        return LocaleKeys.settings_faq.tr();
      case MoreMenuItem.logout:
        return LocaleKeys.account_profile_logout_title.tr();
    }
  }

  @override
  SvgGenImage? get icon {
    switch (this) {
      case MoreMenuItem.profile:
        return Assets.icons.iconoirProfileCircle;
      case MoreMenuItem.addresses:
        return Assets.icons.ionLocationSharp;
      case MoreMenuItem.coupons:
        return Assets.icons.fluentMail28Regular;
      case MoreMenuItem.settings:
        return Assets.icons.solarSettingsBroken;
      case MoreMenuItem.privacy:
        return Assets.icons.weuiLockOutlined;
      case MoreMenuItem.terms:
        return Assets.icons.iconParkOutlineTransactionOrder;
      case MoreMenuItem.contact:
        return Assets.icons.component6;
      case MoreMenuItem.faq:
        return Assets.icons.fluentMail28Regular;
      case MoreMenuItem.logout:
        return Assets.icons.streamlineLogout1;
      default:
        return null;
    }
  }

  @override
  AssetGenImage? get image {
    switch (this) {
      case MoreMenuItem.wallet:
        return Assets.images.wallet;
      case MoreMenuItem.about:
        return Assets.images.logoBLight;
      default:
        return null;
    }
  }

  @override
  BaseRoute? get route {
    switch (this) {
      case MoreMenuItem.profile:
        return AppRoutes.profile;
      case MoreMenuItem.wallet:
        return AppRoutes.wallet;
      case MoreMenuItem.addresses:
        return AppRoutes.addresses;
      case MoreMenuItem.coupons:
        return AppRoutes.coupons;
      case MoreMenuItem.settings:
        return AppRoutes.settings;
      case MoreMenuItem.about:
      case MoreMenuItem.privacy:
      case MoreMenuItem.terms:
        return AppRoutes.staticPage;
      case MoreMenuItem.faq:
        return AppRoutes.faq;
      case MoreMenuItem.contact:
        return AppRoutes.contact;
      default:
        return null;
    }
  }

  @override
  bool get isDestructive => this == MoreMenuItem.logout;

  @override
  Object? get arguments {
    switch (this) {
      case MoreMenuItem.about:
        return StaticPage.about;
      case MoreMenuItem.privacy:
        return StaticPage.privacy;
      case MoreMenuItem.terms:
        return StaticPage.terms;
      default:
        return null;
    }
  }

  @override
  Color? get iconBackgroundColor {
    switch (this) {
      case MoreMenuItem.wallet:
        return LightThemeColors.primary[100];
      case MoreMenuItem.about:
        return LightThemeColors.primary[100];
      case MoreMenuItem.logout:
        return LightThemeColors.error.shade100;
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
      case MoreMenuItem.profile:
      case MoreMenuItem.wallet:
      case MoreMenuItem.addresses:
      case MoreMenuItem.coupons:
      case MoreMenuItem.logout:
        return true;
      default:
        return false;
    }
  }

  bool get isLogout => this == MoreMenuItem.logout;

  static List<MoreMenuItem> items(bool isAuthorized) {
    return MoreMenuItem.values.where((item) => item.needAuthorization ? isAuthorized : true).toList();
  }
}
