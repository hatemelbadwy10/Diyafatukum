import 'package:flutter/material.dart';

import '../../../../../../../core/resources/type_defs.dart';

mixin ContactUsMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BodyMap get body => {
    'name': nameController.text,
    'phone': phoneController.text,
    'message': messageController.text,
  };

  bool validateForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      return true;
    }
    return false;
  }

  void disposeControllers() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    messageController.dispose();
  }
}
