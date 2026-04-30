import 'package:flutter/material.dart';

import '../../../../../../../core/config/flavor/flavor_config.dart';

mixin LoginMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<Map<String, dynamic>> get body async => {
        'identifier': identifierController.text.trim(),
        'password': passwordController.text,
        'user_role': FlavorConfig.isProvider ? 'provider' : 'user',
      };

  void disposeVariables() {
    identifierController.dispose();
    passwordController.dispose();
  }
}
