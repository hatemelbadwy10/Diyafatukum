import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_input_field.dart';
import '../../../../../../../core/widgets/custom_phone_field.dart';
import '../../../../../../../core/widgets/custom_text_field.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../../../verification/data/model/verification_type_enum.dart';
import '../../../data/model/login_type.dart';
import '../../controller/auth_cubit/auth_cubit.dart';
import '../../controller/login_cubit/login_cubit.dart';
import '../../controller/login_cubit/login_mixin.dart';
import '../widgets/forget_password_button.dart';
import '../widgets/login_title.dart';
import '../widgets/sign_up_button.dart';
import '../widgets/social_login_button.dart';

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
          onSuccess: (auth) {
            context.read<AuthCubit>().updateAuthData(auth);
            if (auth.isVerified) {
              if (widget.onLoginSuccess != null) {
                widget.onLoginSuccess?.call();
              } else {
                bottomNavNotifier.value.navigate();
              }
            } else {
              AppRoutes.verification.push(
                extra: {"type": VerificationType.register, "onVerificationSuccess": widget.onLoginSuccess},
                queries: {'identifier': auth.user.phone},
              );
            }
          },
          onFailed: (error) => Toaster.showToast(error.message),
        ),
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar.build(
              actions: [
                CustomTextButton(
                  alignIconEnd: true,
                  matchTextDirection: !context.isRTL,
                  label: LocaleKeys.auth_login_guest.tr(),
                  textStyle: context.titleLarge.s12.regular,
                  onPressed: () {
                    bottomNavNotifier.value = NavigationBarItems.home;
                    AppRoutes.home.go();
                  },
                ).paddingEnd(16),
              ],
            ),
            body: Form(
              key: formKey,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoginTitle(),
                      8.gap,
                      Text(LocaleKeys.auth_login_subtitle.tr(), style: context.bodyLarge.regular.s12).paddingEnd(60),
                      24.gap,
                      CustomPhoneField(controller: identifierController, showRequiredIndicator: false),
                      16.gap,
                      CustomTextField(
                        isRequired: true,
                        showRequiredIndicator: false,
                        inputType: InputType.password,
                        controller: passwordController,
                        title: LocaleKeys.auth_password_title.tr(),
                        hint: LocaleKeys.auth_password_title.tr().enterHint,
                        prefixIcon: Assets.icons.eyeOutlined.path,
                      ),
                      4.gap,
                      ForgetPasswordButton(onTap: () => AppRoutes.forgetPassword.push()),
                      32.gap,
                      CustomButton.gradient(
                        isLoading: state.status.isLoading,
                        label: LocaleKeys.auth_login_title.tr(),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(await body);
                          }
                        },
                      ).setHero(HeroTags.mainButton),
                      20.gap,
                      Text(LocaleKeys.auth_login_or.tr()).center(),
                      20.gap,
                      // ...LoginType.values.map((type) {
                      //   return SocialLoginButton(type: type).paddingBottom(16);
                      // }),
                      16.gap,
                      SignUpButton(isLogin: true, onTap: () => AppRoutes.register.push()),
                    ],
                  ).withListView(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
