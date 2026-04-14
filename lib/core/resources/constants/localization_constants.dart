import 'package:flutter/material.dart';

class LocalizationConstants {
  static const String localeFolderPath = 'assets/lang';

  static const Locale localeEN = Locale('en', 'US');
  static const Locale localeAR = Locale('ar', 'SA');

  static const Locale favoriteLang = localeAR;
  static const List<Locale> supportedLocales = [localeAR, localeEN];
}
