import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CustomEditIconButton extends StatelessWidget {
  const CustomEditIconButton({super.key, this.onTap, this.svg, this.icon, this.color, this.size = 24});
  final void Function()? onTap;
  final SvgGenImage? svg;
  final IconData? icon;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ((svg != null)
            ? svg!.svg(colorFilter: color?.colorFilter, height: size)
            : (icon != null)
            ? Icon(icon, color: (color ?? context.primaryColor), size: size)
            : Assets.icons.editSquare.svg(colorFilter: (color ?? context.primaryColor).colorFilter, height: size))
        .paddingAll(4)
        .onTap(onTap, borderRadius: 8.borderRadius);
  }
}
