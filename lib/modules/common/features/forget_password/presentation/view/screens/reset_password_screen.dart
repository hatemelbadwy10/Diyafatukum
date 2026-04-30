import 'package:deals/modules/common/features/auth/presentation/view/widgets/auth_background_scaffold.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/utils/validators.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../../../../core/widgets/success_dialog.dart';
import '../../controller/reset_password_cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.token, required this.identifier});
  final String token;
  final String identifier;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (_) {
            SuccessDialog(
              title: LocaleKeys.auth_password_change_success.tr(),
              subtitle: LocaleKeys.auth_password_reset_success_subtitle.tr(),
              onCompleted: () => AppRoutes.login.go(),
            ).show(context);
          },
        ),
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.auth_password_reset.tr(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.auth_password_set.tr(),
                    style: context.displaySmall.medium.s18,
                  ),
                  8.gap,
                  Text(
                    LocaleKeys.auth_password_set_subtitle.tr(),
                    style: context.bodyLarge.regular.s12.setHeight(1.6),
                  ),
                  24.gap,
                  CustomTextField(
                    isRequired: false,
                    inputType: InputType.password,
                    controller: _passwordController,
                    title: LocaleKeys.auth_password_new.tr(),
                    hint: LocaleKeys.auth_password_new.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                  ),
                  16.gap,
                  CustomTextField(
                    inputType: InputType.password,
                    controller: _confirmPasswordController,
                    title: LocaleKeys.auth_password_confirm_new.tr(),
                    hint: LocaleKeys.auth_password_confirm_new.tr().enterHint,
                    prefixIcon: Assets.icons.eyeOutlined.path,
                    validator: (_) => Validator.validateConfirmPassword(
                      _confirmPasswordController.text,
                      _passwordController.text,
                    ),
                  ),
                  32.gap,
                  CustomButton(
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.actions_submit.tr(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ResetPasswordCubit>().resetPassword(
                          identifier: widget.identifier,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                          token: widget.token,
                        );
                      }
                    },
                  ).setHero(HeroTags.secondaryButton),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
