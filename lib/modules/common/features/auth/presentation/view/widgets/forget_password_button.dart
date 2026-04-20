import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class ForgetPasswordButton extends StatelessWidget {
  const ForgetPasswordButton({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomTextButton(
          label: LocaleKeys.auth_password_forget.tr(),
          textStyle: context.displayMedium.regular.s12.underline.setColor(context.errorColor),
          onPressed: onTap,
        ),
      ],
    );
  }
}
