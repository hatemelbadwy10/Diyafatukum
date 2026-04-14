import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/resources.dart';
import '../extensions/all_extensions.dart';
import 'light_theme.dart';

class AppThemeManager {
  const AppThemeManager._();

  static ValueNotifier<bool> darkModeEnabled = ValueNotifier(false);
  static void setStatusBarAndNavigationBarColors(ThemeMode themeMode) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness: themeMode == ThemeMode.light ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  static ButtonStyle elevatedButtonStyleTheme({
    required Color buttonColor,
    required Color textColor,
    Color? buttonColorDisabled,
    Color? buttonColorPressed,
    Color? textColorPressed,
  }) {
    return ButtonStyle(
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      textStyle: WidgetStateProperty.all<TextStyle>(TextStylesManager.font.s16.bold),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.buttonBorderRadius)),
      ),
      splashFactory: NoSplash.splashFactory,
      minimumSize: WidgetStateProperty.all<Size>(const Size(double.infinity, AppSize.buttonHeight)),
      elevation: WidgetStateProperty.all(0),
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return buttonColorPressed ?? buttonColor.withValues(alpha: .75);
        } else if (states.contains(WidgetState.disabled)) {
          return buttonColorDisabled ?? LightThemeColors.disabledButton;
        }
        return buttonColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return textColorPressed ?? textColor;
        } else if (states.contains(WidgetState.disabled)) {
          return LightThemeColors.grey[50]!;
        }
        return textColor;
      }),
    );
  }

  static ButtonStyle textButtonStyleTheme({
    required Color textColor,
    Color? backgroundColor,
    Color? textColorPressed,
    Color? backgroundColorPressed,
  }) {
    return ButtonStyle(
      shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
      textStyle: WidgetStateProperty.all<TextStyle>(TextStylesManager.font.s14.regular),
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      minimumSize: WidgetStateProperty.all(const Size(0, AppSize.buttonHeightSmall)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(4.edgeInsetsAll),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return backgroundColorPressed ?? Colors.transparent;
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return textColorPressed ?? textColor.withValues(alpha: 0.5);
        }
        return textColor;
      }),
    );
  }
}
