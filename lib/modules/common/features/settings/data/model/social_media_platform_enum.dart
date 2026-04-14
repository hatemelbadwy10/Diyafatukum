import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../core/config/extensions/all_extensions.dart';

abstract class SocialMedia {
  String get title;
  String get hint;
  bool get enable;
  SvgGenImage get icon;
  Color? get iconColor;
  Gradient? get iconGradient => null;
}

enum SocialMediaPlatform implements SocialMedia {
  whatsapp,
  facebook,
  instagram,
  snapchat,
  tiktok,
  x;

  @override
  String get title {
    switch (this) {
      case SocialMediaPlatform.whatsapp:
        return LocaleKeys.details_contact_social_whatsapp.tr();
      case SocialMediaPlatform.facebook:
        return LocaleKeys.details_contact_social_facebook.tr();
      case SocialMediaPlatform.instagram:
        return LocaleKeys.details_contact_social_instagram.tr();
      case SocialMediaPlatform.snapchat:
        return LocaleKeys.details_contact_social_snapchat.tr();
      case SocialMediaPlatform.tiktok:
        return LocaleKeys.details_contact_social_tiktok.tr();
      case SocialMediaPlatform.x:
        return LocaleKeys.details_contact_social_x.tr();
    }
  }

  @override
  String get hint {
    switch (this) {
      case SocialMediaPlatform.whatsapp:
        return LocaleKeys.details_contact_social_url_whatsapp.tr();
      case SocialMediaPlatform.facebook:
        return LocaleKeys.details_contact_social_url_facebook.tr();
      case SocialMediaPlatform.instagram:
        return LocaleKeys.details_contact_social_url_instagram.tr();
      case SocialMediaPlatform.snapchat:
        return LocaleKeys.details_contact_social_url_snapchat.tr();
      case SocialMediaPlatform.tiktok:
        return LocaleKeys.details_contact_social_url_tiktok.tr();
      case SocialMediaPlatform.x:
        return LocaleKeys.details_contact_social_url_x.tr();
    }
  }

  // @override
  // SvgGenImage get icon {
  //   switch (this) {
  //     case SocialMediaPlatform.whatsapp:
  //       return Assets.icons.whatsapp;
  //     case SocialMediaPlatform.facebook:
  //       return Assets.icons.facebook;
  //     case SocialMediaPlatform.instagram:
  //       return Assets.icons.instagram;
  //     case SocialMediaPlatform.snapchat:
  //       return Assets.icons.snapchat;
  //     case SocialMediaPlatform.tiktok:
  //       return Assets.icons.tiktok;
  //     case SocialMediaPlatform.x:
  //       return Assets.icons.x;
  //   }
  // }

  String get key {
    switch (this) {
      case SocialMediaPlatform.whatsapp:
        return 'whats_app';
      case SocialMediaPlatform.facebook:
        return 'facebook';
      case SocialMediaPlatform.instagram:
        return 'instagram';
      case SocialMediaPlatform.snapchat:
        return 'snapchat';
      case SocialMediaPlatform.tiktok:
        return 'tiktok';
      case SocialMediaPlatform.x:
        return 'twitter';
    }
  }

  void launch(String body) {
    if (this == SocialMediaPlatform.whatsapp) {
      body.launchWhatsApp();
    } else {
      body.openUrl();
    }
  }

  @override
  Color? get iconColor {
    switch (this) {
      case SocialMediaPlatform.whatsapp:
        return Color(0xFF6FDA65);
      case SocialMediaPlatform.facebook:
        return Color(0xFF2C64F5);
      case SocialMediaPlatform.snapchat:
        return Color(0xFFFFFC00);
      case SocialMediaPlatform.tiktok:
        return Color(0xFF69C9D0);
      case SocialMediaPlatform.x:
        return Color(0xFF000000);
      default:
        return null;
    }
  }

  @override
  Gradient? get iconGradient {
    if (this == SocialMediaPlatform.instagram) {
      return GradientStyles.secondaryGradient();
    }
    return null;
  }

  @override
  bool get enable {
    switch (this) {
      case SocialMediaPlatform.whatsapp:
        return true;
      case SocialMediaPlatform.facebook:
        return true;
      case SocialMediaPlatform.instagram:
        return true;
      case SocialMediaPlatform.snapchat:
        return false;
      case SocialMediaPlatform.tiktok:
        return false;
      case SocialMediaPlatform.x:
        return true;
    }
  }

  static Map<SocialMediaPlatform, String> fromJson(Map<String, dynamic> json) {
    final Map<SocialMediaPlatform, String> result = {};

    for (final platform in SocialMediaPlatform.values) {
      if (!platform.enable) continue;

      final value = json[platform.key];

      if (value == null) continue;

      if (value is String && value.isNotEmpty) {
        result[platform] = value;
      } else if (value is List && value.isNotEmpty) {
        // Handle phones array
        result[platform] = value.first;
      }
    }

    return result;
  }
  
  @override
  // TODO: implement icon
  SvgGenImage get icon => throw UnimplementedError();
}
