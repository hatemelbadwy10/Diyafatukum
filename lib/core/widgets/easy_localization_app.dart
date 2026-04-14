import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../resources/constants/localization_constants.dart';

class EasyLocalizationApp extends StatelessWidget {
  const EasyLocalizationApp({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      saveLocale: true,
      ignorePluralRules: false,
      supportedLocales: LocalizationConstants.supportedLocales,
      path: LocalizationConstants.localeFolderPath,
      startLocale: LocalizationConstants.favoriteLang,
      child: child,
    );
  }
}
