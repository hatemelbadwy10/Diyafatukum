import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../config/router/route_manager.dart';
import 'buttons/custom_buttons.dart';
import 'custom_dialog.dart';

class CustomDeleteButton extends StatelessWidget {
  const CustomDeleteButton({
    super.key,
    this.onDeleted,
    this.deleteLabel,
    this.title,
    this.subtitle,
    this.size = 16,
    this.backgroundColor,
  });

  final void Function()? onDeleted;
  final String? deleteLabel;
  final String? title;
  final String? subtitle;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomIconButton.svg(
      svg: Assets.icons.trash,
      size: size,
      padding: 6.edgeInsetsAll,
      borderRadius: 100,
      backgroundColor: backgroundColor ?? context.errorSwatch.shade100,
      foregroundColor: context.errorColor,
      onPressed: () => context.showDialog(
        CustomDialog(
          actions: [
            DialogAction(
              label: deleteLabel ?? LocaleKeys.actions_delete.tr(),
              onPressed: onDeleted,
              isDestructive: true,
            ),
            DialogAction(label: LocaleKeys.actions_cancel.tr(), onPressed: () => BaseRouter.pop()),
          ],
          // isDestructive: true,
          // onConfirm: onDeleted,
          subtitle: subtitle,
          title: title ?? LocaleKeys.actions_delete.tr(),
          // confirmLabel: deleteLabel ?? LocaleKeys.actions_delete.tr(),
        ),
      ),
    );
  }
}
