import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CustomSeeAllButton extends StatelessWidget {
  const CustomSeeAllButton({super.key, this.title, this.onTap, this.padding = 8});

  final String? title;
  final Function()? onTap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${title ?? LocaleKeys.actions_see_all.tr()}>>",
    ).clickable(style: context.titleLarge.s14.medium, padding: padding.edgeInsetsAll, onTap: () => onTap?.call());
  }
}
