import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'buttons/custom_buttons.dart';

class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({super.key, this.center = true, this.onPressed, this.color});
  final bool center;
  final Color? color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton.svg(
      svg: Assets.icons.close,
      onPressed: onPressed ?? () => context.pop(),
      foregroundColor: context.errorColor,
    );
  }
}
