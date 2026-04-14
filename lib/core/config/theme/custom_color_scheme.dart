import 'package:flutter/material.dart';

class CustomColorScheme extends ThemeExtension<CustomColorScheme> {
  final MaterialColor primarySwatch;
  final MaterialColor primaryVariantSwatch;
  final MaterialColor secondarySwatch;
  final MaterialColor tertiarySwatch;
  final MaterialColor accentSwatch;
  final MaterialColor greySwatch;
  final MaterialColor errorSwatch;
  final MaterialColor successSwatch;
  final MaterialColor warningSwatch;

  const CustomColorScheme({
    required this.primarySwatch,
    required this.primaryVariantSwatch,
    required this.secondarySwatch,
    required this.tertiarySwatch,
    required this.accentSwatch,
    required this.greySwatch,
    required this.errorSwatch,
    required this.successSwatch,
    required this.warningSwatch,
  });

  @override
  CustomColorScheme copyWith({
    MaterialColor? primarySwatch,
    MaterialColor? primaryVariantSwatch,
    MaterialColor? secondarySwatch,
    MaterialColor? tertiarySwatch,
    MaterialColor? accentSwatch,
    MaterialColor? greySwatch,
    MaterialColor? errorSwatch,
    MaterialColor? successSwatch,
    MaterialColor? warningSwatch,
  }) {
    return CustomColorScheme(
      primarySwatch: primarySwatch ?? this.primarySwatch,
      primaryVariantSwatch: primaryVariantSwatch ?? this.primaryVariantSwatch,
      secondarySwatch: secondarySwatch ?? this.secondarySwatch,
      tertiarySwatch: tertiarySwatch ?? this.tertiarySwatch,
      accentSwatch: accentSwatch ?? this.accentSwatch,
      greySwatch: greySwatch ?? this.greySwatch,
      errorSwatch: errorSwatch ?? this.errorSwatch,
      successSwatch: successSwatch ?? this.successSwatch,
      warningSwatch: warningSwatch ?? this.warningSwatch,
    );
  }

  @override
  ThemeExtension<CustomColorScheme> lerp(covariant ThemeExtension<CustomColorScheme>? other, double t) {
    if (other is! CustomColorScheme) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
