import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/resources/resources.dart';

enum LoginType {
  google,
  apple;

  String get title {
    switch (this) {
      case LoginType.google:
        return LocaleKeys.auth_login_social_google.tr();
      case LoginType.apple:
        return LocaleKeys.auth_login_social_apple.tr();
    }
  }

  // SvgGenImage get icon {
  //   switch (this) {
  //     case LoginType.google:
  //       return Assets.icons.google;
  //     case LoginType.apple:
  //       return Assets.icons.apple;
  //   }
  // }

  bool get enabled {
    switch (this) {
      case LoginType.google:
        return true;
      case LoginType.apple:
        return Platform.isIOS;
    }
  }
}
