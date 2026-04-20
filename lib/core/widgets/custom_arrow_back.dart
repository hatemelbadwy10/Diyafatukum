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
    return Transform.flip(
      flipX: true,
      child: CustomIconButton.svg(
        svg: Assets.icons.icon,
        matchTextDirection: true,
        size: 20,
        foregroundColor: iconColor?? context.greySwatch.shade900,
        onPressed: onPressed ?? () => context.pop(context),
      ).setContainerToView(
        width: 40,
        height: 40,
        borderColor: context.greySwatch.shade300,
        radius: 12,
      ),
    );
  }
}
