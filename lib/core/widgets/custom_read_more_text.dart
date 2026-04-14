import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:readmore/readmore.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CustomReadMoreText extends StatelessWidget {
  const CustomReadMoreText(this.text, {super.key});

  final String text;
  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: 3,
      locale: context.locale,
      colorClickableText: context.primaryColor,
      trimExpandedText: LocaleKeys.actions_show_less.tr(),
      trimCollapsedText: LocaleKeys.actions_read_more.tr(),
      isExpandable: true,
      moreStyle: context.titleLarge.medium.s14,
      lessStyle: context.titleLarge.medium.s14,
      trimMode: TrimMode.Line,
      style: TextStyle(fontFamily: FontConstants.fontFamily).s14.setColor(context.bodyLarge.color!),
    );
  }
}
