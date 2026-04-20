import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../widgets/auth_background_scaffold.dart';
import 'register_step_two_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.onRegisterSuccess});

  final void Function()? onRegisterSuccess;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _goToNextStep() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await AppRoutes.registerDetails.push(
      extra: RegisterStepTwoArgs(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        onRegisterSuccess: widget.onRegisterSuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScaffold(
      title: LocaleKeys.auth_register_title.tr(),
      bottom: CustomButton.gradient(
        borderRadius: AppSize.buttonBorderRadius,
        label: LocaleKeys.actions_next.tr(),
        onPressed: _goToNextStep,
      ).setHero(HeroTags.mainButton),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.auth_register_subtitle.tr(),
              textAlign: TextAlign.center,
              style: context.bodyLarge.regular.s13.setHeight(1.6),
            ),
            24.gap,
            CustomTextField(
              inputType: InputType.name,
              controller: _nameController,
              showRequiredIndicator: false,
              title: LocaleKeys.details_name.tr(),
              hint: LocaleKeys.details_name.tr().enterHint,
              prefixIcon: Assets.icons.iconoirProfileCircle.path,
            ),
            16.gap,
            CustomTextField(
              isRequired: false,
              inputType: InputType.email,
              controller: _emailController,
              showRequiredIndicator: false,
              title: LocaleKeys.details_contact_email.tr(),
              hint: LocaleKeys.details_contact_email.tr().enterHint,
              prefixIcon: Assets.icons.mail.path,
            ),
            16.gap,
            CustomPhoneField(
              controller: _phoneController,
              showRequiredIndicator: false,
            ),
            16.gap,
          ],
        ),
      ),
    );
  }
}
