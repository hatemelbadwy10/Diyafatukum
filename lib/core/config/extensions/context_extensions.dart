import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../utils/overlay_utils.dart';

double tabletBreakpointGlobal = 600.0;
double desktopBreakpointGlobal = 720.0;

// Context Extensions
extension ContextExtensions on BuildContext {
  /// return screen size
  Size get size => MediaQuery.of(this).size;

  /// return screen width
  double get width => MediaQuery.of(this).size.width;

  /// return screen height
  double get height => MediaQuery.of(this).size.height;

  /// return screen devicePixelRatio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  double responsiveHeight({required double regular, double? large}) {
    if (isBigPhone) {
      return large ?? regular;
    } else {
      return regular;
    }
  }

  /// returns brightness
  Brightness platformBrightness() => MediaQuery.of(this).platformBrightness;

  /// Return the height of status bar
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Return the height of navigation bar
  double get navigationBarHeight => MediaQuery.of(this).padding.bottom;

  /// Returns DefaultTextStyle.of(context)
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// Returns Form.of(context)
  FormState? get formState => Form.of(this);

  /// Returns Scaffold.of(context)
  ScaffoldState get scaffoldState => Scaffold.of(this);

  /// Returns Overlay.of(context)
  OverlayState? get overlayState => Overlay.of(this);

  /// Request focus to given FocusNode
  void requestFocus(FocusNode focus) {
    FocusScope.of(this).requestFocus(focus);
  }

  /// Request focus to given FocusNode
  void unFocus(FocusNode focus) => focus.unfocus();

  /// Return the height of status bar
  bool get isRTL => locale == const Locale('ar', 'SA');

  bool get isBigPhone => MediaQuery.of(this).size.longestSide >= 750;

  bool isPhone() => MediaQuery.of(this).size.width < tabletBreakpointGlobal;

  bool isTablet() =>
      MediaQuery.of(this).size.width < desktopBreakpointGlobal &&
      MediaQuery.of(this).size.width >= tabletBreakpointGlobal;

  bool isDesktop() => MediaQuery.of(this).size.width >= desktopBreakpointGlobal;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  TargetPlatform get platform => Theme.of(this).platform;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isIOS => platform == TargetPlatform.iOS;

  void openDrawer() => Scaffold.of(this).openDrawer();

  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  bool get canPopScreen => GoRouter.of(this).canPop();

  double get keyboardPadding => MediaQuery.of(this).viewInsets.bottom;

  String get languageCode => '${locale.languageCode}_${locale.countryCode}';

  void hideKeyboard() => FocusScope.of(this).unfocus();

  void showKeyboard() => FocusScope.of(this).requestFocus(FocusNode());

  void showDialog(Widget dialog) => OverlayUtils.showCustomDialog(context: this, child: dialog);

  Future<T?> showBottomSheet<T>(Widget bottomSheet) =>
      OverlayUtils.showBottomSheet<T>(context: this, child: bottomSheet);

  Future<T?> showScrollableBottomSheet<T>({Widget? bottom, Widget? title, required Widget body}) =>
      OverlayUtils.showScrollableBottomSheet<T>(context: this, child: body, bottom: bottom, title: title);

  T? maybeRead<T>() {
    try {
      return read<T>();
    } catch (e) {
      return null;
    }
  }

  ui.TextDirection get textDirection => Directionality.of(this);
}

extension DirectionalOffsetExtension on BuildContext {
  /// Gets a slide offset based on text direction and visibility
  /// [isVisible] - if true, returns Offset.zero (normal position)
  /// if false, returns offset based on slideFromStart
  /// [slideFromStart] - if true, slides from start (left in LTR, right in RTL)
  /// if false, slides from end (right in LTR, left in RTL)
  Offset getSlideOffset({bool isVisible = true, bool slideFromStart = true}) {
    if (isVisible) {
      return Offset.zero; // Normal position when visible
    }

    final isLTR = Directionality.of(this) == ui.TextDirection.ltr;

    if (slideFromStart) {
      // Slide from start: off-screen left in LTR, off-screen right in RTL
      return isLTR ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
    } else {
      // Slide from end: off-screen right in LTR, off-screen left in RTL
      return isLTR ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
    }
  }
}
