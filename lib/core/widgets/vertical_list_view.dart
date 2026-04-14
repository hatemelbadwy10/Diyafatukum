import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class VerticalListView extends StatelessWidget {
  const VerticalListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding,
    this.title,
    this.titleStyle,
    this.enableScroll = true,
    this.height = 120,
    this.spacing = 16,
    this.separator,
    this.onRefresh,
    this.titlePadding,
    this.controller,
    this.shrinkWrap = false,
  });

  final int itemCount;
  final double height;
  final bool enableScroll;
  final double spacing;
  final String? title;
  final double? titlePadding;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? Function(BuildContext, int) itemBuilder;
  final Widget? separator;
  final Future<void> Function()? onRefresh;
  final ScrollController? controller;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    if (onRefresh != null) {
      return RefreshIndicator.adaptive(onRefresh: onRefresh!, child: _buildListView(context));
    } else {
      return _buildListView(context);
    }
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      controller: controller,
      itemCount: itemCount,
      shrinkWrap: !enableScroll,
      physics: enableScroll ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.screenPadding),
      separatorBuilder: (_, _) => separator ?? spacing.gap,
      itemBuilder: itemBuilder,
    ).setTitle(
      title: title,
      gap: 8,
      titlePadding: titlePadding ?? padding?.horizontal ?? 0,
      titleStyle: titleStyle ?? context.titleLarge.regular.s14.setHeight(2),
    );
  }
}
