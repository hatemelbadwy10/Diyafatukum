import 'package:flutter/material.dart';

import '../../../core/config/theme/light_theme.dart';

enum ButtonColorScheme {
  primary,
  secondary,
  tertiary,
  destructive,
  warning,
  success;

  Color? get surface {
    switch (this) {
      case ButtonColorScheme.primary:
        return LightThemeColors.primary;
      case ButtonColorScheme.secondary:
        return LightThemeColors.primary;
      case ButtonColorScheme.tertiary:
        return LightThemeColors.primary;
      case ButtonColorScheme.destructive:
        return LightThemeColors.error.shade100;
      case ButtonColorScheme.warning:
        return LightThemeColors.warning.shade100;
      case ButtonColorScheme.success:
        return LightThemeColors.success.shade100;
    }
  }

  Color? get color {
    switch (this) {
      case ButtonColorScheme.primary:
        return LightThemeColors.primary[600];
      case ButtonColorScheme.secondary:
        return LightThemeColors.secondary;
      case ButtonColorScheme.tertiary:
        return LightThemeColors.tertiary;
      case ButtonColorScheme.destructive:
        return LightThemeColors.error;
      case ButtonColorScheme.warning:
        return LightThemeColors.warning;
      case ButtonColorScheme.success:
        return LightThemeColors.success;
    }
  }
}

enum ButtonBackgroundType { solid, gradient }

enum ButtonContentType { icon, svg, text }

enum ButtonSize { small, medium, large }

enum ButtonShape { rounded, stadium }

enum ButtonBorderStyle { none, outlined }

enum ButtonType { elevated, text }
