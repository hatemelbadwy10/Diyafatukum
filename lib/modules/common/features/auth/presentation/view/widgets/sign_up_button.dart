import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key, this.isLogin = true, this.onTap});
  final bool isLogin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final String button = isLogin ? LocaleKeys.auth_register_title.tr() : LocaleKeys.auth_login_title.tr();
    final String title = isLogin ? LocaleKeys.auth_login_have_account.tr() : LocaleKeys.auth_register_have_account.tr();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: context.titleLarge.s13.regular),
        CustomTextButton(
          label: button,
          textStyle: context.titleLarge.s13.copyWith(color: context.tertiarySwatch[800]!).underline,
          onPressed: onTap,
        ),
      ],
    );
  }
}
