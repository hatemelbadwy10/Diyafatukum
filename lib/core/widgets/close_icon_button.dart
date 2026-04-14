import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CloseIconButton extends StatelessWidget {
  const CloseIconButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Assets.icons.close
        .svg(colorFilter: context.iconDisabledColor.colorFilter, height: 20)
        .center()
        .withSize(12, 12)
        .onTap(onPressed);
  }
}
