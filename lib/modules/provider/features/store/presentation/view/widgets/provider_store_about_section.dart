import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/resources/resources.dart';

class ProviderStoreAboutSection extends StatelessWidget {
  const ProviderStoreAboutSection({
    super.key,
    required this.description,
    required this.highlights,
    required this.onTap,
  });

  final String description;
  final List<String> highlights;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.screenPadding,
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
             
              Text(
                LocaleKeys.provider_store_about_title.tr(),
                style: context.titleMedium.bold,
              ),
                            const Spacer(),

               Assets.icons.editCopy.svg(
                width: 24,
                height: 24,
                colorFilter: context.greySwatch.shade800.colorFilter,
              ),
            ],
          ),
          14.gap,
          Text(
            description,
            style: context.bodyMedium.regular.s14.setColor(context.greySwatch.shade600).setHeight(1.7),
          ),
          if (highlights.isNotEmpty) ...[
            12.gap,
            ...highlights.map(
              (highlight) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: context.bodyMedium.bold.setColor(context.greySwatch.shade700),
                  ),
                  8.gap,
                  Text(
                    highlight,
                    style: context.bodyMedium.regular.s14.setColor(context.greySwatch.shade600).setHeight(1.6),
                  ).expand(),
                ],
              ).paddingBottom(8),
            ),
          ],
        ],
      ),
    ).onTap(onTap);
  }
}
