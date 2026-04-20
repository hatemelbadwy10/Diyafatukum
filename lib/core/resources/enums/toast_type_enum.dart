import 'package:flutter/material.dart';

import '../../config/theme/light_theme.dart';

enum ToastType {
  success,
  warning,
  error;

  Color get color {
    switch (this) {
      case ToastType.success:
        return LightThemeColors.success;
      case ToastType.warning:
        return LightThemeColors.warning;
      case ToastType.error:
        return LightThemeColors.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ToastType.success:
        return LightThemeColors.success.shade50;
      case ToastType.warning:
        return LightThemeColors.warning.shade50;
      case ToastType.error:
        return LightThemeColors.error.shade50;
    }
  }

  // SvgGenImage get icon {
  //   switch (this) {
  //     case ToastType.success:
  //       return Assets.icons.succ;
  //     case ToastType.warning:
  //       return Assets.icons.warning;
  //     case ToastType.error:
  //       return Assets.icons.error;
  //   }
  // }
}
