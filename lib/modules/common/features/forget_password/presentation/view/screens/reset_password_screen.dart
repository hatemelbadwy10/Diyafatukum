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
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) => state.status.listen(
          onFailed: (failure) => Toaster.showToast(failure.message),
          onSuccess: (_) => AppRoutes.login.go(),
        ),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar.build(),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(LocaleKeys.auth_password_set.tr(), style: context.displaySmall.medium.s18),
                  8.gap,
                  Text(
                    LocaleKeys.auth_password_new.tr().enterHint,
                    style: context.bodyLarge.regular.s12,
                    textAlign: TextAlign.center,
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
                    validator: (_) =>
                        Validator.validateConfirmPassword(_confirmPasswordController.text, _passwordController.text),
                  ),
                  32.gap,
                  CustomButton(
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.actions_submit.tr(),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ResetPasswordCubit>().resetPassword(
                              token: widget.token,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            );
                      }
                    },
                  ).setHero(HeroTags.secondaryButton),
                ],
              ).withListView(),
            ),
          );
        },
      ),
    );
  }
}
