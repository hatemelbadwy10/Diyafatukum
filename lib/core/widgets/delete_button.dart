import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/overlay_utils.dart';
import '../../../../../../../core/widgets/custom_dialog.dart';
import '../config/router/route_manager.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.onDeleted, required this.title});

  final void Function() onDeleted;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Assets.icons.trash
        .svg(colorFilter: context.iconColor.colorFilter, height: AppSize.iconNormal)
        .setBorder(radius: 4, padding: 6, color: context.primaryContainerColor)
        .onTap(() {
          OverlayUtils.showCustomDialog(
            context: context,
            child: CustomDialog(
              actions: [
                DialogAction(label: LocaleKeys.actions_clear.tr(), onPressed: onDeleted, isDestructive: true),
                DialogAction(label: LocaleKeys.actions_cancel.tr(), onPressed: () => BaseRouter.pop()),
              ],
              title: title,
            ),
          );
        }, borderRadius: 4.borderRadius)
        .paddingEnd(AppSize.screenPadding);
  }
}
