import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/app_dialog.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key, this.message, this.onSuccess});
  final String? message;
  final void Function()? onSuccess;

  Future<T?> show<T>(BuildContext context) {
    return AppDialog(
      title: LocaleKeys.auth_guest_login_first.tr(),
      subtitle: message ?? LocaleKeys.auth_guest_login_hint.tr(),
      confirmLabel: LocaleKeys.auth_login_title.tr(),
      cancelLabel: LocaleKeys.auth_register_title.tr(),
      onConfirm: () => AppRoutes.login.push(extra: onSuccess),
      onCancel: () => AppRoutes.register.push(extra: onSuccess),
      icon: const Icon(
        Icons.priority_high_rounded,
        color: Colors.white,
        size: 28,
      ),
      iconBackgroundColor: context.errorColor,
      dismissible: true,
    ).show<T>(context);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
