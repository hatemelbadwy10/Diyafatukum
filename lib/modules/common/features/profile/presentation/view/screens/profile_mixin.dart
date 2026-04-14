import '../../../data/model/user_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/resources/type_defs.dart';

mixin ProfileMixin {
  final ValueNotifier<bool> isEditingNotifier = ValueNotifier<bool>(false);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  BodyMap get body => {'name': nameController.text, 'email': emailController.text, 'username': phoneController.text};

  void toggleEditing() => isEditingNotifier.value = !isEditingNotifier.value;

  bool get isValidForm {
    return formKey.currentState?.validate() ?? false;
  }

  void init(UserModel user) {
    nameController.text = user.name;
    phoneController.text = user.phone;
    emailController.text = user.email ?? '';
  }

  void disposeVariables() {
    isEditingNotifier.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
  }

  bool isProfileUpdated(UserModel user) {
    return user.name == nameController.text && user.email == emailController.text;
  }
}
