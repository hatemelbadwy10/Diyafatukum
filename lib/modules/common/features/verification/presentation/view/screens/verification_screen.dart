import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_pin_field.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../auth/presentation/view/widgets/custom_timer.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../../data/model/verification_type_enum.dart';
import '../../controller/verification_cubit/verification_cubit.dart';
import '../../controller/verification_cubit/verification_mixin.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    this.code,
    required this.identifier,
    this.type = VerificationType.register,
    this.onVerificationSuccess,
  });

  final String? code;
  final String identifier;
  final VerificationType type;
  final void Function()? onVerificationSuccess;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> with VerificationMixin {
  @override
  void initState() {
    init(phone: widget.identifier, code: widget.code);
    super.initState();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VerificationCubit>()..setType(widget.type),
      child: BlocConsumer<VerificationCubit, VerificationState>(
        listener: (context, state) {
          state.status.listen(
            onFailed: (failure) => Toaster.showToast(failure.message),
            onSuccess: (data) {
              final authCubit = context.read<AuthCubit>();
              widget.type.onVerified(
                onForgetPassword: () {
                  AppRoutes.resetPassword.pushReplacement(queries: {'identifier': widget.identifier, 'token': data});
                },
                onChangePhone: () {
                  authCubit.updateAuthData(data);
                  Toaster.showToast(LocaleKeys.account_profile_change_phone_success.tr(), isError: false);
                  context.pop();
                  context.pop();
                },
                onRegister: () {
                  authCubit.updateAuthData(data);
                  if (widget.onVerificationSuccess != null) {
                    widget.onVerificationSuccess?.call();
                  } else {
                    bottomNavNotifier.value.navigate();
                  }
                },
              );
            },
          );
          state.resendStatus.listen(onFailed: (failure) => Toaster.showToast(failure.message));
        },
        builder: (context, state) {
          final cubit = context.read<VerificationCubit>();
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final auth = authState.auth;
              return Scaffold(
                appBar: CustomAppBar.build(removeBack: false, backgroundColor: context.scaffoldBackgroundColor),
                body: Form(
                  key: formKey,
                  child: ListView(
                    padding: AppSize.screenPadding.edgeInsetsHorizontal,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(LocaleKeys.auth_otp_title.tr(), style: context.displaySmall.regular.s18),
                          12.gap,
                          Row(
                            children: [
                              Text(LocaleKeys.auth_otp_hint.tr(), style: context.bodyLarge.regular.s12),
                              4.gap,
                              Directionality(
                                textDirection: ui.TextDirection.ltr,
                                child: Text(
                                  "${widget.type == VerificationType.changeEmail ? "" : "+20"} "
                                  "${widget.identifier}",
                                  style: context.displayMedium.regular.s14,
                                ),
                              ),
                            ],
                          ).paddingEnd(60),
                          48.gap,
                          CustomPinInputField(
                            controller: otpController,
                            onCompleted: (code) {
                              if (isFormValid) {
                                cubit.verify(auth: auth, body: body);
                              }
                            },
                          ),
                          48.gap,
                          CustomButton.gradient(
                            isLoading: state.status.isLoading,
                            label: LocaleKeys.actions_submit.tr(),
                            onPressed: () {
                              if (isFormValid) {
                                cubit.verify(auth: auth, body: body);
                              }
                            },
                          ).setHero(HeroTags.mainButton),
                          32.gap,
                          CustomTimer(
                            isLoading: state.resendStatus.isLoading,
                            onRestart: () {
                              otpController.clear();
                              cubit.resendCode(phone: widget.identifier);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
