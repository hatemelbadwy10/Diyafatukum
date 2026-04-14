import 'package:flutter/material.dart';

import '../config/theme/light_theme.dart';
import 'resources.dart';

class TextStylesManager {
  const TextStylesManager._();
  static TextStyle font = TextStyle(fontFamily: FontConstants.fontFamily, height: 1.2);
}

class ShadowStyles {
  const ShadowStyles._();
  static List<BoxShadow> bottomSheetShadow = [
    BoxShadow(color: LightThemeColors.shadowBottomSheet, blurRadius: 30, offset: const Offset(0, 4), spreadRadius: 0),
  ];

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x00779af1).withValues(alpha: .2),
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> bannerShadow = [
    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2), spreadRadius: 1),
  ];
}

class GradientStyles {
  const GradientStyles._();
  static LinearGradient primaryGradientPressed = LinearGradient(
    begin: AlignmentDirectional.centerEnd,
    end: AlignmentDirectional.centerStart,
    colors: LightThemeColors.primaryGradient,
    stops: const [.1, .6, .9],
  );
  static LinearGradient primaryGradient = LinearGradient(
    begin: AlignmentDirectional.centerEnd,
    end: AlignmentDirectional.centerStart,
    colors: LightThemeColors.primaryGradient,
  );

  static LinearGradient secondaryGradient({double? radius}) => LinearGradient(
    transform: radius != null ? GradientRotation(radius) : null,
    begin: AlignmentDirectional.centerEnd,
    end: AlignmentDirectional.centerStart,
    colors: LightThemeColors.secondaryGradient,
  );

  static LinearGradient tertiaryGradient = LinearGradient(
    begin: AlignmentDirectional.topCenter,
    end: AlignmentDirectional.bottomCenter,
    colors: LightThemeColors.tertiaryGradient,
  );

  // disabled gradient
  static LinearGradient disabledGradient = LinearGradient(
    begin: AlignmentDirectional.centerEnd,
    end: AlignmentDirectional.centerStart,
    colors: LightThemeColors.disabledGradient,
  );
}
