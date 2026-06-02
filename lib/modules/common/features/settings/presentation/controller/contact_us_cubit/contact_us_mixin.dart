import 'package:flutter/material.dart';

import '../../../../../../../core/resources/type_defs.dart';
import '../../../../profile/data/model/user_model.dart';

mixin ContactUsMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  BodyMap buildBody({UserModel? user, required bool isGuest}) => {
    'name': isGuest ? nameController.text : user?.name ?? '',
    'phone': isGuest ? phoneController.text : user?.phone ?? '',
    'email': isGuest ? emailController.text : user?.email ?? '',
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
