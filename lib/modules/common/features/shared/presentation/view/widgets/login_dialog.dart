
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_dialog.dart';


class LoginDialog extends CustomDialog {
  const LoginDialog({super.key, this.message, this.onSuccess});
  final String? message;
  final void Function()? onSuccess;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: Assets.images.logoHorizontalLight.image(),
      subtitle: message ?? LocaleKeys.auth_login_subtitle.tr(),
      confirmLabel: LocaleKeys.auth_login_title.tr(),
      cancelLabel: LocaleKeys.auth_register_title.tr(),
      onConfirm: () => AppRoutes.login.push(extra: onSuccess),
      onCancel: () => AppRoutes.register.push(extra: onSuccess),
    );
  }
}
