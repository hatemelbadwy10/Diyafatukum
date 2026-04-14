import 'package:flutter/material.dart';

import '../../../../../../../core/resources/type_defs.dart';

mixin VerificationMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController codeController = TextEditingController();

  BodyMap get body => {
        'code': otpController.text,
        'username': phoneController.text,
        'username_type': 'phone',
        'test_mode': '1',
      };

  bool get isFormValid => formKey.currentState?.validate() ?? false;

  void init({required String phone, String? code}) {
    phoneController.text = phone;
    codeController.text = code ?? '';
  }

  void disposeControllers() {
    otpController.dispose();
    phoneController.dispose();
    codeController.dispose();
  }
}
