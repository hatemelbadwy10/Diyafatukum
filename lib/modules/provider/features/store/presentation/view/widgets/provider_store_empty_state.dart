import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/widgets/buttons/custom_buttons.dart';

class ProviderStoreEmptyState extends StatelessWidget {
  const ProviderStoreEmptyState({super.key, required this.onAddProductTap});

  final VoidCallback onAddProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        34.gap,
        Icon(
          Icons.add_rounded,
          size: 42,
          color: context.primaryColor,
        ).center().setContainerToView(
          width: 82,
          height: 82,
          radius: 41,
          borderColor: context.primaryColor,
          borderWidth: 2,
        ),
        26.gap,
        Text(
          LocaleKeys.provider_store_empty_title.tr(),
          style: context.displaySmall.bold.s18,
          textAlign: TextAlign.center,
        ),
        10.gap,
        Text(
          LocaleKeys.provider_store_empty_subtitle.tr(),
          style: context.bodyMedium.regular.s14.setColor(context.greySwatch.shade500),
          textAlign: TextAlign.center,
        ).paddingHorizontal(28),
        28.gap,
        CustomButton.gradient(
          width: 170,
          height: 50,
          borderRadius: 8,
          label: LocaleKeys.provider_store_actions_add_product.tr(),
          onPressed: onAddProductTap,
        ),
      ],
    );
  }
}
