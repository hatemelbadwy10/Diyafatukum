import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'custom_input_field.dart';
import 'custom_text_field.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final double? fontSize;
  final ValueChanged<String>? onChangedCode;
  final bool readOnly;
  final bool showPrefixIcon;
  final void Function()? onTap;
  final AutovalidateMode? autovalidateMode;
  final bool enabled;
  final Widget? titleIcon;
  final bool showRequiredIndicator;

  const CustomPhoneField({
    super.key,
    this.onTap,
    this.fontSize,
    this.readOnly = false,
    this.showPrefixIcon = true,
    this.controller,
    this.onChangedCode,
    this.autovalidateMode,
    this.enabled = true,
    this.titleIcon,
    this.showRequiredIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: ui.TextDirection.ltr,
      children: [
        Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Directionality(textDirection: ui.TextDirection.ltr, child: Text('+966', style: context.hintTextStyle)),
                8.gap,
                Assets.icons.fluentMail28Regular.svg(height: 24, width: 24),
              ],
            )
            .paddingHorizontal(8)
            .setContainerToView(
              radius: AppSize.mainRadius,
              color: context.surfaceColor,
              height: AppSize.buttonHeight,
              borderColor: context.inputFieldBorderColor,
            ),
        8.gap,
        CustomTextField(
          enabled: enabled,
          isRequired: true,
          hint: '5XXXXXXX',
          onTap: onTap,
          readOnly: readOnly,
          controller: controller,
          textAlign: TextAlign.left,
          inputType: InputType.phone,
          autovalidateMode: autovalidateMode,
          onChanged: onChangedCode,
          prefixIcon: showPrefixIcon ? Assets.icons.mdiPhoneOutline.path : null,
        ).expand(),
      ],
    ).setTitle(titleWidget: _getTitleWidget(context), titleIcon: titleIcon);
  }

  Widget _getTitleWidget(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          if (showRequiredIndicator) TextSpan(text: '* ', style: context.errorStyle.regular.s14),
          TextSpan(text: LocaleKeys.details_contact_phone.tr(), style: context.titleLarge.s14.regular),
        ],
      ),
    );
  }
}
