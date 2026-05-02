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
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_check_box.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../../../verification/data/model/verification_type_enum.dart';
import '../../../data/model/auth_model.dart';
import '../../controller/auth_cubit/auth_cubit.dart';
import '../../controller/login_cubit/login_cubit.dart';
import '../../controller/login_cubit/login_mixin.dart';
import '../widgets/auth_background_scaffold.dart';
import '../widgets/forget_password_button.dart';
import '../widgets/sign_up_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.onLoginSuccess});

  final void Function()? onLoginSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginMixin {
  @override
  void dispose() {
    disposeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) => state.status.listen(
          onSuccess: (response) {
            final auth = response.auth;
            if (auth != null) {
              context.read<AuthCubit>().updateAuthData(auth);
            }

            if (response.requiresVerification) {
              AppRoutes.verification.push(
                extra: {
                  "type": VerificationType.register,
                  "onVerificationSuccess": widget.onLoginSuccess,
                },
                queries: {
                  'identifier': response.identifier,
                  if (response.otp?.isNotEmpty ?? false) 'code': response.otp,
                },
              );
            } else if (auth != null && auth.isVerified) {
              if (widget.onLoginSuccess != null) {
                widget.onLoginSuccess?.call();
              } else {
                bottomNavNotifier.value.navigate();
              }
            } else if (auth != null) {
              AppRoutes.verification.push(
                extra: {
                  "type": VerificationType.register,
                  "onVerificationSuccess": widget.onLoginSuccess,
                },
                queries: {'identifier': auth.user.email ?? auth.user.phone},
              );
            }
          },
          onFailed: (error) => Toaster.showToast(error.message),
        ),
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.auth_login_title.tr(),
            onBackPressed: () => AppRoutes.onboarding.go(),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.auth_login_subtitle.tr(),
                    style: context.bodyLarge.regular.s13.setHeight(1.6),
                  ),
                  24.gap,
                  CustomTextField(
                    controller: identifierController,
                    showRequiredIndicator: false,
                    inputType: InputType.email,
                    title: LocaleKeys.details_contact_email.tr(),
                    hint: LocaleKeys.details_contact_email.tr().enterHint,
                    prefixIcon: Assets.icons.mail.path,
                  ),
                  16.gap,
                  CustomTextField(
                    isRequired: true,
                    showRequiredIndicator: false,
                    inputType: InputType.password,
                    controller: passwordController,
                    title: LocaleKeys.auth_password_title.tr(),
                    hint: LocaleKeys.auth_password_title.tr().enterHint,
                    prefixIcon: Assets.icons.weuiLockOutlined.path,
                  ),
                  8.gap,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomCheckBox(
                        label: Text(
                          LocaleKeys.auth_login_remember.tr(),
                          style: context.bodyLarge.regular.s12,
                        ),
                        onChanged: (_) {},
                      ),
                      ForgetPasswordButton(
                        onTap: () => AppRoutes.forgetPassword.push(),
                      ),
                    ],
                  ),
                  28.gap,
                  CustomButton.gradient(
                    borderRadius: AppSize.buttonBorderRadius,
                    isLoading: state.status.isLoading,
                    label: LocaleKeys.auth_login_title.tr(),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginCubit>().login(await body);
                      }
                    },
                  ).setHero(HeroTags.mainButton),
                  20.gap,
                  Text(
                    LocaleKeys.auth_login_or.tr(),
                    style: context.bodyLarge.regular.s12,
                  ).center(),
                  20.gap,
                  // ...LoginType.values.map((type) {
                  //   return SocialLoginButton(type: type).paddingBottom(16);
                  // }),
                  16.gap,
                  SignUpButton(
                    isLogin: true,
                    onTap: () => FlavorConfig.isProvider
                        ? AppRoutes.providerHome.push()
                        : AppRoutes.register.push(),
                  ),
                  8.gap,
                  CustomTextButton(
                    alignIconEnd: true,
                    matchTextDirection: !context.isRTL,
                    label: LocaleKeys.auth_login_guest.tr(),
                    textStyle: context.titleLarge.s13.regular.underline,
                    onPressed: () {
                      context.read<AuthCubit>().updateAuthData(
                        const AuthModel.guest(),
                      );
                      bottomNavNotifier.value = NavigationBarItems.home;
                      AppRoutes.home.go();
                    },
                  ).center(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
