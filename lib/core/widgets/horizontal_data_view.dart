import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';

class HorizontalDataView extends StatelessWidget {
  const HorizontalDataView({
    super.key,
    required this.title,
    required this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.titleIcon,
    this.subtitleIcon,
    this.iconSpacing = 4.0,
    this.gap = 8.0,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });
  final String title;
  final String subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? titleIcon;
  final Widget? subtitleIcon;
  final double iconSpacing;
  final double gap;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [_buildTitleWithIcon(context), gap.gap, _buildSubtitleWithIcon(context).flexible()],
    );
  }

  Widget _buildTitleWithIcon(BuildContext context) {
    if (titleIcon == null) {
      return Text(title, style: titleStyle ?? context.bodySmall.s12.regular);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleIcon!,
        iconSpacing.gap,
        Text(title, style: titleStyle ?? context.bodySmall.s12.regular),
      ],
    );
  }

  Widget _buildSubtitleWithIcon(BuildContext context) {
    if (subtitleIcon == null) {
      return Text(subtitle, style: subtitleStyle ?? context.bodyLarge.s12.medium, overflow: TextOverflow.ellipsis);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        subtitleIcon!,
        iconSpacing.gap,
        Text(
          subtitle,
          style: subtitleStyle ?? context.bodyLarge.s12.medium,
          overflow: TextOverflow.ellipsis,
        ).flexible(),
      ],
    );
  }
}
