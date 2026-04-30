import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deals/modules/common/features/auth/data/model/auth_model.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/toaster_utils.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_pin_field.dart';
import '../../../../auth/presentation/view/widgets/auth_background_scaffold.dart';
import '../../../../auth/presentation/view/widgets/custom_timer.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../controller/verification_cubit/verification_cubit.dart';
import '../../../data/model/verification_type_enum.dart';

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

class _VerificationScreenState extends State<VerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.code?.isNotEmpty ?? false) {
      _otpController.text = widget.code!;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String get _maskedIdentifier {
    final id = widget.identifier;
    if (id.contains('@')) {
      return '${id.split('@').first}@******';
    }
    if (id.length <= 4) return id;
    final visible = id.substring(id.length - 4);
    return '${'*' * (id.length - 4)}$visible';
  }

  String get _usernameType =>
      widget.identifier.contains('@') ? 'email' : 'phone';

  Map<String, dynamic> get _verificationBody {
    switch (widget.type) {
      case VerificationType.register:
        return {
          'identifier': widget.identifier.trim(),
          'otp': _otpController.text.trim(),
          'register': true,
        };
      case VerificationType.changePhone:
        return {
          'identifier': widget.identifier.trim(),
          'otp': _otpController.text.trim(),
          'is_phone': true,
        };
      default:
        return {
          'code': _otpController.text.trim(),
          'username': widget.identifier.trim(),
          'username_type': _usernameType,
          'test_mode': '1',
        };
    }
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<VerificationCubit>().verify(body: _verificationBody);
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
              widget.type.onVerified(
                onForgetPassword: () => AppRoutes.resetPassword.pushReplacement(
                  extra: {
                    'identifier': widget.identifier,
                    'token': data as String,
                  },
                ),
                onRegister: () {
                  if (data is AuthModel) {
                    context.read<AuthCubit>().updateAuthData(data);
                  }
                  if (widget.onVerificationSuccess != null) {
                    widget.onVerificationSuccess?.call();
                  } else {
                    bottomNavNotifier.value.navigate();
                  }
                },
                onChangePhone: () => widget.onVerificationSuccess?.call(),
                onChangeEmail: () => widget.onVerificationSuccess?.call(),
              );
            },
          );

          state.resendStatus.listen(
            onFailed: (failure) => Toaster.showToast(failure.message),
          );
        },
        builder: (context, state) {
          return AuthBackgroundScaffold(
            title: LocaleKeys.auth_otp_title.tr(),
            bottom: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton.gradient(
                  borderRadius: AppSize.buttonBorderRadius,
                  isLoading: state.status.isLoading,
                  label: LocaleKeys.actions_submit.tr(),
                  onPressed: () => _submit(context),
                ).setHero(HeroTags.mainButton),
                16.gap,
                CustomTimer(
                  isLoading: state.resendStatus.isLoading,
                  onRestart: () {
                    _otpController.clear();
                    context.read<VerificationCubit>().resendCode(
                      identifier: widget.identifier.trim(),
                    );
                  },
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: context.isRTL
                        ? ui.TextDirection.rtl
                        : ui.TextDirection.ltr,
                    child: Text.rich(
                      TextSpan(
                        style: context.bodyLarge.regular.s13.setHeight(1.6),
                        children: [
                          TextSpan(text: '${LocaleKeys.auth_otp_hint.tr()} '),
                          TextSpan(
                            text: _maskedIdentifier,
                            style: context.displayLarge.regular.s13
                                .setColor(context.greySwatch.shade900)
                                .bold,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  32.gap,
                  CustomPinInputField(
                    controller: _otpController,
                    onCompleted: (_) => _submit(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
