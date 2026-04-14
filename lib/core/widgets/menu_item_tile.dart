import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../modules/common/features/settings/data/model/base_menu_item_model.dart';
import '../config/extensions/all_extensions.dart';
import '../resources/resources.dart';



class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    super.key,
    required this.item,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
    this.enableBorder = false,
    this.isDestructive = false,
    this.enabled = true,
    this.trailing,
    this.padding,
    this.iconSize = AppSize.iconNormal,
  });

  final BaseMenuItem item;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final void Function()? onTap;
  final bool enableBorder;
  final bool isDestructive;
  final bool enabled;
  final Widget? trailing;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        color: enableBorder ? context.surfaceColor : null,
        border: enableBorder ? Border.all(color: context.customColorScheme.primarySwatch.shade100) : null,
        borderRadius: enableBorder ? AppSize.mainRadius.borderRadius : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: enableBorder ? AppSize.mainRadius.borderRadius : null,
        child:
            Container(
                  padding: enableBorder ? padding ?? 16.0.edgeInsetsAll : null,
                  child: Row(
                    children: [
                      ...[
                        if (item.image != null)
                          item.image!
                              .image(height: iconSize, width: iconSize, fit: BoxFit.cover)
                              .setContainerToView(
                                color: item.iconBackgroundColor ?? iconBackgroundColor,
                                radius: 100,
                                padding: 6,
                              )
                              .clipRRect(100)
                        else if (item.icon != null)
                          item.icon!
                              .svg(
                                height: iconSize,
                                colorFilter:
                                    (isDestructive
                                            ? context.errorColor
                                            : iconColor ?? item.iconColor ?? context.iconColor)
                                        .colorFilter,
                              )
                              .setContainerToView(
                                color: item.iconBackgroundColor ?? iconBackgroundColor,
                                radius: 100,
                                padding: 6,
                              ),
                        16.gap,
                      ],
                      Text(
                        item.title.tr(),
                        style: isDestructive ? context.errorStyle.s14.regular : context.bodyLarge.s14.regular,
                      ).expand(),
                      trailing ??
                          Assets.icons.arrowLeft
                              .svg(height: iconSize, colorFilter: context.iconColor.colorFilter)
                              .flipHorizontal(enable: !context.isRTL),
                    ],
                  ),
                )
                .onTap(
                  enableBorder
                      ? () {
                          onTap?.call();
                          item.route?.push(extra: item.arguments);
                        }
                      : null,
                  borderRadius: AppSize.mainRadius.borderRadius,
                )
                .paddingSymmetric(enableBorder ? 0 : AppSize.screenPadding, enableBorder ? 0 : 16)
                .onTap(
                  !enableBorder
                      ? () {
                          onTap?.call();
                          item.route?.push(extra: item.arguments);
                        }
                      : null,
                ),
      ),
    );
  }
}
