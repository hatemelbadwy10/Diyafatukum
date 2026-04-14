import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'buttons/custom_buttons.dart';

class CustomArrowBack extends StatelessWidget {
  const CustomArrowBack({super.key, this.iconColor, this.onPressed});
  final Color? iconColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton.svg(
      svg: Assets.icons.arrowLeftAlt,
      matchTextDirection: true,
      foregroundColor: context.onPrimary,
      onPressed: onPressed ?? () => context.pop(context),
    );
  }
}
