import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/flavor/flavor_config.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_check_box.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../settings/data/model/static_page_enum.dart';
import '../../../../verification/data/model/verification_type_enum.dart';
import '../../controller/register_cubit/register_cubit.dart';
import '../../controller/register_cubit/register_mixin.dart';
import '../widgets/auth_background_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.onRegisterSuccess});
  final void Function()? onRegisterSuccess;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with RegisterMixin {
  @override
  void dispose() {
    disposeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) => state.status.listen(
          onSuccess: (_) {
            AppRoutes.verification.push(
              extra: {"type": VerificationType.register, "onVerificationSuccess": widget.onRegisterSuccess},
              queries: {'identifier': phoneController.text},
            );
          },
          onFailed: (failure) => Toaster.showToast(failure.message),
        ),
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.auth_register_title.tr(),
            bottom: CustomButton.gradient(
              isLoading: state.status.isLoading,
              label: LocaleKeys.auth_register_title.tr(),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (!isTermsAccepted.value) {
                    Toaster.showToast(LocaleKeys.auth_register_accept_terms_required.tr());
                  } else {
                    context.read<RegisterCubit>().register(await body);
                  }
                }
              },
            ).setHero(HeroTags.mainButton),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(LocaleKeys.auth_register_welcome.tr(), style: context.displaySmall.regular.s18),
                      4.gap,
                      Text(FlavorConfig.displayName, style: context.displayMedium.regular.s18),
                    ],
                  ),
                  12.gap,
                  Text(
                    LocaleKeys.auth_register_subtitle.tr(),
                    style: context.bodyLarge.regular.s13.setHeight(1.6),
                  ),
                  24.gap,
                  CustomTextField(
                    inputType: InputType.name,
                    controller: nameController,
                    title: LocaleKeys.details_name.tr(),
                    hint: LocaleKeys.details_name.tr().enterHint,
                    prefixIcon: Assets.icons.iconoirProfileCircle.path,
                  ),
                  16.gap,
                  CustomPhoneField(controller: phoneController),
                  16.gap,
                  CustomTextField(
                    isRequired: false,
                    inputType: InputType.email,
                    controller: emailController,
                    title: LocaleKeys.details_contact_email.tr(),
                    hint: LocaleKeys.details_contact_email.tr().enterHint,
                    prefixIcon: Assets.icons.fluentMail28Regular.path,
                  ),
                  16.gap,
                  CustomTextField(
                    inputType: InputType.password,
                    controller: passwordController,
                    title: LocaleKeys.auth_password_title.tr(),
                    hint: LocaleKeys.auth_password_title.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                  ),
                  16.gap,
                  CustomTextField(
                    inputType: InputType.password,
                    controller: confirmPasswordController,
                    title: LocaleKeys.auth_password_confirm.tr(),
                    hint: LocaleKeys.auth_password_confirm.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                    validator: (value) => Validator.validateConfirmPassword(value, passwordController.text),
                  ),
                  16.gap,
                  CustomCheckBox(
                    onChanged: (value) => isTermsAccepted.value = value,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(LocaleKeys.auth_register_accept_terms_title.tr(), style: context.bodyLarge.regular.s12),
                        4.gap,
                        CustomTextButton(
                          label: LocaleKeys.settings_terms.tr(),
                          textStyle: context.displayLarge.regular.underline.s12,
                          onPressed: () => AppRoutes.staticPage.push(extra: StaticPage.terms),
                        ),
                      ],
                    ),
                  ),
                  16.gap,
                ],
              ).withListView(
                padding: AppSize.screenPadding.edgeInsetsHorizontal.copyWith(top: 8, bottom: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}
