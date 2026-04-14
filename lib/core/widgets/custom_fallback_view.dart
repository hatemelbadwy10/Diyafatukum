import 'package:flutter/material.dart';

import '../config/extensions/all_extensions.dart';
import 'buttons/custom_button.dart';

class CustomFallbackView extends StatelessWidget {
  const CustomFallbackView({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonPressed,
    this.padding = 52,
  });

  final Widget? icon;
  final String? title;
  final String? subtitle;
  final String? buttonLabel;
  final Function()? onButtonPressed;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, 16.gap],
        if (title != null) Text(title!, style: context.bodyLarge.s16.medium, textAlign: TextAlign.center).center(),
        if (subtitle != null)
          Text(subtitle!, style: context.bodyMedium.s14.regular, textAlign: TextAlign.center).center().paddingTop(4),
        if (buttonLabel != null) ...[32.gap, CustomButton(label: buttonLabel!, onPressed: onButtonPressed ?? () {})],
      ],
    ).paddingHorizontal(padding).center();
  }
}
