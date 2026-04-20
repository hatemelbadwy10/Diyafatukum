import 'package:flutter/material.dart';

import '../theme/custom_color_scheme.dart';
import 'all_extensions.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  // buttonStyle
  ButtonStyle get elevatedButtonStyle => theme.elevatedButtonTheme.style!;
  ButtonStyle get textButtonStyle => theme.textButtonTheme.style!;

  // ColorScheme
  CustomColorScheme get customColorScheme => theme.extension<CustomColorScheme>()!;
  MaterialColor get primarySwatch => customColorScheme.primarySwatch;
  MaterialColor get primaryVariantSwatch => customColorScheme.primaryVariantSwatch;
  MaterialColor get secondarySwatch => customColorScheme.secondarySwatch;
  MaterialColor get tertiarySwatch => customColorScheme.tertiarySwatch;
  MaterialColor get accentSwatch => customColorScheme.accentSwatch;
  MaterialColor get greySwatch => customColorScheme.greySwatch;
  MaterialColor get errorSwatch => customColorScheme.errorSwatch;
  MaterialColor get successSwatch => customColorScheme.successSwatch;
  MaterialColor get warningSwatch => customColorScheme.warningSwatch;

  ColorScheme get colorScheme => theme.colorScheme;

  // primary color
  Color get primaryColor => theme.colorScheme.primary;

  // secondary color
  Color get secondaryColor => theme.colorScheme.secondary;
  // tertiary color
  Color get tertiaryColor => theme.colorScheme.tertiary;
  // accent color
  Color get accentColor => accentSwatch.shade500;

  // surface color
  Color get surfaceColor => theme.colorScheme.surface;
  Color get primaryContainerColor => colorScheme.primaryContainer;
  Color get secondaryContainerColor => colorScheme.secondaryContainer;
  Color get tertiaryContainerColor => colorScheme.tertiaryContainer;

  // disabled color
  Color get disabledColor => theme.cardColor;

  Color get primaryCardColor => theme.cardColor;
  Color get secondaryCardColor => theme.cardTheme.color!;

  // background color
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  Color get bottomSheetBackground => theme.bottomSheetTheme.backgroundColor!;

  // validation colors
  Color get errorColor => theme.colorScheme.error;
  Color get warningColor => warningSwatch.shade500;
  Color get successColor => successSwatch.shade500;

  Color get errorContainer => theme.colorScheme.error;

  Color get disabledButtonColor => labelLarge.color!;

  // input decoration
  TextStyle get hintTextStyle => theme.inputDecorationTheme.hintStyle!;
  Color get fillColor => theme.inputDecorationTheme.fillColor!;
  Color get inputFieldBorderColor => theme.inputDecorationTheme.border!.borderSide.color;
  Color get hintColor => theme.inputDecorationTheme.hintStyle!.color!;
  Color get inputFieldIconsColor => bodySmall.color!;

  Color get primaryBorder => primarySwatch.shade500;
  Color get secondaryBorder => greySwatch.shade300;
  Color get variantBorderColor => greySwatch.shade200;

  Color get primaryDividerColor => theme.dividerColor;
  Color get secondaryDividerColor => theme.dividerTheme.color!;

  // icons
  IconThemeData? get iconTheme => theme.appBarTheme.iconTheme;
  Color get iconColor => theme.iconTheme.color!;
  Color get iconSecondaryColor => bodyMedium.color!;
  Color get iconDisabledColor => labelLarge.color!;
  Color get iconInactiveColor => labelMedium.color!;
  Color get iconSelectedColor => theme.bottomNavigationBarTheme.selectedItemColor!;
  Color get iconUnselectedColor => theme.bottomNavigationBarTheme.unselectedItemColor!;

  Color get onPrimary => theme.colorScheme.onPrimary;

  // TextTheme
  TextTheme get textTheme => theme.textTheme;
  TextStyle get displayLarge => textTheme.displayLarge!;
  TextStyle get displayMedium => textTheme.displayMedium!;
  TextStyle get displaySmall => textTheme.displaySmall!;
  TextStyle get headlineLarge => textTheme.headlineLarge!;
  TextStyle get headlineMedium => textTheme.headlineMedium!;
  TextStyle get headlineSmall => textTheme.headlineSmall!;

  /// grey swatch shade 950
  TextStyle get titleLarge => textTheme.titleLarge!;

  /// grey swatch shade 900
  TextStyle get titleMedium => textTheme.titleMedium!;

  /// grey swatch shade 800
  TextStyle get titleSmall => textTheme.titleSmall!;

  /// grey swatch shade 700
  TextStyle get bodyLarge => textTheme.bodyLarge!;

  /// grey swatch shade 600
  TextStyle get bodyMedium => textTheme.bodyMedium!;

  /// grey swatch shade 500
  TextStyle get bodySmall => textTheme.bodySmall!;

  /// grey swatch shade 400
  TextStyle get labelLarge => textTheme.labelLarge!;

  /// grey swatch shade 200
  TextStyle get labelMedium => textTheme.labelMedium!;

  /// grey swatch shade 100
  TextStyle get labelSmall => textTheme.labelSmall!;

  // Text styles
  TextStyle get errorStyle => textTheme.headlineLarge!.s12.regular;
  TextStyle get successStyle => textTheme.headlineSmall!.s13.regular;
  TextStyle get warningStyle => textTheme.headlineMedium!.s13.regular;
  TextStyle get bottomNavBarSelectedLabelStyle => theme.bottomNavigationBarTheme.selectedLabelStyle!;
  TextStyle get bottomNavBarUnselectedLabelStyle => theme.bottomNavigationBarTheme.unselectedLabelStyle!;
  // input field text styles
  TextStyle get inputFieldTextStyle => titleLarge.s14.regular.setHeight(1.5);
  TextStyle get inputFieldHintTextStyle => bodyMedium.s12.regular.setHeight(1.5);
  TextStyle get inputFieldLabelTextStyle => bodyMedium.s12.regular;
  TextStyle get inputFieldErrorTextStyle => headlineLarge.s12.regular;
  TextStyle get inputFieldDisabledTextStyle => bodySmall.s14.medium.setHeight(1.5);
}
