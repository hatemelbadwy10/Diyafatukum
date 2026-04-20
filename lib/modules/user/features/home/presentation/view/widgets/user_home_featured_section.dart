import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';

class UserHomeFeaturedSection extends StatelessWidget {
  const UserHomeFeaturedSection({
    super.key,
    required this.titleKey,
    required this.subtitleKey,
  });

  final String titleKey;
  final String subtitleKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titleKey.tr(),
          style: context.titleSmall.bold.s24,
          textAlign: TextAlign.center,
        ),
        8.gap,
        Text(
          subtitleKey.tr(),
          style: context.bodyLarge.regular.s16.setHeight(1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
