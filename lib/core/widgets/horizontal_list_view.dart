import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class HorizontalListView extends StatelessWidget {
  const HorizontalListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.title,
    this.padding,
    this.titleStyle,
    this.height = 120,
    this.enableScroll = true,
    this.separatorWidth = 16,
    this.titleAction,
  });

  final int itemCount;
  final double height;
  final double separatorWidth;
  final String? title;
  final TextStyle? titleStyle;
  final bool enableScroll;
  final EdgeInsetsGeometry? padding;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget? titleAction;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
          itemCount: itemCount,
          shrinkWrap: enableScroll ? false : true,
          scrollDirection: Axis.horizontal,
          physics: enableScroll ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
          separatorBuilder: (_, _) => separatorWidth.gap,
          itemBuilder: itemBuilder,
        )
        .withHeight(height)
        .setTitle(
          title: title?.capitalizeFirstOfEach,
          gap: 8,
          titlePadding: AppSize.screenPadding,
          titleStyle: titleStyle ?? context.bodyLarge.bold.s16.setHeight(2),
          titleIcon: titleAction,
        );
  }
}
