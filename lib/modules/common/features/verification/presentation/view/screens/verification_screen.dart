import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/constants/hero_tags.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_pin_field.dart';
import '../../../../auth/presentation/view/widgets/auth_background_scaffold.dart';
import '../../../../auth/presentation/view/widgets/custom_timer.dart';
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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.type.onVerified(
      onForgetPassword: () => AppRoutes.resetPassword.pushReplacement(
        extra: {
          'identifier': widget.identifier,
          'token': 'mock-token',
        },
      ),
      onRegister: () => widget.onVerificationSuccess?.call(),
      onChangePhone: () => widget.onVerificationSuccess?.call(),
      onChangeEmail: () => widget.onVerificationSuccess?.call(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackgroundScaffold(
      title: LocaleKeys.auth_otp_title.tr(),
      bottom: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton.gradient(
            borderRadius: AppSize.buttonBorderRadius,
            label: LocaleKeys.actions_submit.tr(),
            onPressed: _submit,
          ).setHero(HeroTags.mainButton),
          16.gap,
          CustomTimer(
            onRestart: () => _otpController.clear(),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Directionality(
              textDirection:
                  context.isRTL ? ui.TextDirection.rtl : ui.TextDirection.ltr,
              child: Text.rich(
                TextSpan(
                  style: context.bodyLarge.regular.s13.setHeight(1.6),
                  children: [
                    TextSpan(text: '${LocaleKeys.auth_otp_hint.tr()} '),
                    TextSpan(
                      text: _maskedIdentifier,
                      style: context.displayLarge.regular.s13.setColor(context.greySwatch.shade900).bold,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            32.gap,
            CustomPinInputField(
              controller: _otpController,
              onCompleted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}
