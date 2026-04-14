import 'package:flutter/material.dart';

import '../../../../../../../core/resources/type_defs.dart';

mixin PasswordMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  BodyMap get body => {
    'current_password': oldPasswordController.text,
    'password': passwordController.text,
    'password_confirmation': confirmPasswordController.text,
  };

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  void resetForm() {
    formKey.currentState!.reset();
    oldPasswordController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void disposeControllers() {
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
