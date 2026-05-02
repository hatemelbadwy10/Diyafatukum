

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/extensions/theme_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_button.dart';




class GuestLoginView extends StatelessWidget {
  const GuestLoginView({
    super.key,
    this.title,
    this.subtitle,
    this.imagePath,
    this.iconPath,
    this.iconSize = AppSize.iconLarge,
    this.iconColor,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.showBackground = true,
  });

  final SvgGenImage? iconPath;
  final AssetGenImage? imagePath;
  final String? title;
  final String? subtitle;
  final double iconSize;
  final Color? iconColor;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showBackground;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconPath != null)
                  iconPath!.svg(
                    height: iconSize,
                    width: iconSize,
                    colorFilter: ColorFilter.mode(iconColor ?? context.iconDisabledColor, BlendMode.srcIn),
                  )
                else if (imagePath != null)
                  imagePath!.image(height: iconSize),
                if (title != null) ...[6.gap, Text(title!, style: titleStyle ?? context.titleLarge.s14.medium)],
                12.gap,
                if (subtitle != null)
                  Text(subtitle!, style: subtitleStyle ?? context.bodyMedium.s12.regular, textAlign: TextAlign.center),
                24.gap,
                CustomButton(onPressed: () => AppRoutes.login.push(), label: LocaleKeys.auth_login_title.tr()),
                12.gap,
                CustomButton.outlined(
                  onPressed: () => AppRoutes.register.push(),
                  label: LocaleKeys.auth_register_title.tr(),
                ),
                12.gap,
              ],
            )
            .paddingHorizontal(backgroundColor != null ? 25 : 0)
            .setContainerToView(
              alignment: Alignment.topCenter,
              color: backgroundColor,
              radius: backgroundColor != null ? 6 : null,
              padding: backgroundColor != null ? 12 : null,
            )
            .center(),
      ],
    ).paddingHorizontal(backgroundColor != null ? AppSize.screenPadding : 55);
  }
}
