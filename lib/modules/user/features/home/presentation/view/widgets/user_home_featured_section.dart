import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class UserHomeFeaturedSection extends StatelessWidget {
  const UserHomeFeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys.home_user_featured_title.tr(),
          style: context.titleSmall.bold.s24,
          textAlign: TextAlign.center,
        ),
        8.gap,
        Text(
          LocaleKeys.home_user_featured_subtitle.tr(),
          style: context.bodyLarge.regular.s16.setHeight(1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
