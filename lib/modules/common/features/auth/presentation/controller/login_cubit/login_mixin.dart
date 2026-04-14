import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/route_manager.dart';

mixin LoginMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Map<String, dynamic>> get body async => {
        "test_mode": 1,
        "username_type": "phone",
        'username': identifierController.text.neglectStartingZero,
        'password': passwordController.text,
        'preferred_locale': rootNavigatorKey.currentContext?.locale.languageCode ?? 'en',
        'device_token': 'test',
        // 'device_token': await RemoteNotificationServices.getFcmToken()
      };

  void disposeVariables() {
    identifierController.dispose();
    passwordController.dispose();
  }
}
