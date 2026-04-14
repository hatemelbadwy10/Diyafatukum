import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/constants/localization_constants.dart';
import '../../../../../../../core/resources/resources.dart';


class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(context.isRTL ? 'ENG' : 'عربي', style: context.bodyLarge.s14.bold),
        8.gap,
        Assets.icons.mdiGiftOutline.svg(),
      ],
    ).paddingAll(8).onTap(() {
      if (context.isRTL) {
        context.setLocale(LocalizationConstants.localeEN);
        sl<ApiClient>().updateLanguage('en');
      } else {
        context.setLocale(LocalizationConstants.localeAR);
        sl<ApiClient>().updateLanguage('ar');
      }
    }, borderRadius: 8.borderRadius).paddingHorizontal(AppSize.screenPadding);
  }
}
