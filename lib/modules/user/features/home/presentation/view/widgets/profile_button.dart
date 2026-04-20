import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Assets.icons.person.path
        .toSvg(color: context.onPrimary, width: 26, height: 26)
        .onTap(() {}, borderRadius: 18.borderRadius)
        .setContainerToView(
          width: 56,
          height: 56,
          color: context.primaryColor,
          radius: 18,
        );
  }
}
