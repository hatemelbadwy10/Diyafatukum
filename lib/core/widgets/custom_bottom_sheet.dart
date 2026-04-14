import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.actions = const [],
    this.centerTitle = false,
    this.leadingIcon,
  });
  final Widget? leadingIcon;
  final Widget child;
  final String? title;
  final List<Widget> actions;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              spacing: 8,
              mainAxisAlignment: centerTitle ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                if (leadingIcon != null) leadingIcon!,
                Text(title!, style: context.bodyLarge.medium.s16),
                if (actions.isNotEmpty) ...[const Spacer(), ...actions],
              ],
            ).paddingHorizontal(AppSize.screenPadding),
            16.gap,
          ],
          child,
        ],
      ).withSafeArea(minimum: 16.edgeInsetsOnlyBottom),
    );
  }
}
