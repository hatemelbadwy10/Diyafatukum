import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../core/resources/type_defs.dart';

mixin RegisterMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> isTermsAccepted = ValueNotifier<bool>(false);

  Future<BodyMap> get body async => {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text.neglectStartingZero,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'accept_terms': isTermsAccepted.value ? 1 : 0,
        'device_token': 'test',
        // 'device_token': await RemoteNotificationServices.getFcmToken()
        'preferred_locale': rootNavigatorKey.currentContext?.locale.languageCode ?? 'en',
      };

  void disposeVariables() {
    isTermsAccepted.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
