import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/utils/validators.dart';
import '../../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../common/features/auth/presentation/view/widgets/auth_background_scaffold.dart';
import '../../../data/model/provider_register_request_model.dart';
import 'provider_register_location_screen.dart';

class ProviderRegisterScreen extends StatefulWidget {
  const ProviderRegisterScreen({super.key});

  @override
  State<ProviderRegisterScreen> createState() => _ProviderRegisterScreenState();
}

class _ProviderRegisterScreenState extends State<ProviderRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _commercialRegisterController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _commercialRegisterController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _goToLocationStep() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await AppRoutes.providerRegisterLocation.push(
      extra: ProviderRegisterLocationArguments(
        request: ProviderRegisterRequestModel(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim().neglectStartingZero,
          commercialRegister: _commercialRegisterController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScaffold(
      title: LocaleKeys.provider_register_title.tr(),
      bottom: CustomButton.gradient(
        borderRadius: AppSize.buttonBorderRadius,
        label: LocaleKeys.actions_next.tr(),
        onPressed: _goToLocationStep,
      ).setHero(HeroTags.mainButton),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              LocaleKeys.provider_register_subtitle.tr(),
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
            CustomPhoneField(
              controller: _phoneController,
              showRequiredIndicator: false,
            ),
            16.gap,
            CustomTextField(
              controller: _commercialRegisterController,
              showRequiredIndicator: false,
              keyboardType: TextInputType.number,
              inputType: InputType.number,
              title: LocaleKeys.provider_register_commercial_register.tr(),
              hint: LocaleKeys.provider_register_commercial_register.tr()
                  .enterHint,
              prefixIcon: Assets.icons.stashShopSolid.path,
            ),
            16.gap,
            CustomTextField(
              inputType: InputType.password,
              controller: _passwordController,
              showRequiredIndicator: false,
              title: LocaleKeys.auth_password_title.tr(),
              hint: LocaleKeys.auth_password_title.tr().enterHint,
              prefixIcon: Assets.icons.weuiLockOutlined.path,
            ),
            16.gap,
            CustomTextField(
              inputType: InputType.password,
              controller: _confirmPasswordController,
              showRequiredIndicator: false,
              title: LocaleKeys.auth_password_confirm.tr(),
              hint: LocaleKeys.auth_password_confirm.tr().enterHint,
              prefixIcon: Assets.icons.weuiLockOutlined.path,
              validator: (value) => Validator.validateConfirmPassword(
                value,
                _passwordController.text,
              ),
            ),
            16.gap,
          ],
        ),
      ),
    );
  }
}
