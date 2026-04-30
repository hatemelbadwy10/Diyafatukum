import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_search_field.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../data/model/user_home_model.dart';
import 'user_home_banner.dart';
import 'user_home_featured_section.dart';
import 'user_home_header.dart';
import 'user_service_card.dart';

class UserHomeBody extends StatelessWidget {
  const UserHomeBody({
    super.key,
    required this.data,
    required this.onSearchChanged,
    this.searchQuery = '',
  });

  final UserHomeModel data;
  final ValueChanged<String> onSearchChanged;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (context.width - (AppSize.screenPadding * 2) - 16) / 2;
    final hasNoResults = data.services.isEmpty;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSize.screenPadding,
        16,
        AppSize.screenPadding,
        kBottomNavigationBarHeight + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const UserHomeHeader(),
          24.gap,
          CustomSearchField(
            hintText: LocaleKeys.home_user_search_hint.tr(),
            readOnly: false,
            onChanged: onSearchChanged,
            onTap: () {},
          ),
          24.gap,
          UserHomeBanner(data: data),
          32.gap,
          const UserHomeFeaturedSection(),
          24.gap,
          if (hasNoResults)
            CustomFallbackView(
              title: LocaleKeys.search_not_found.tr(),
              subtitle: searchQuery.isNotEmpty
                  ? LocaleKeys.search_no_results_msg.tr(args: [searchQuery])
                  : LocaleKeys.search_not_found_subtitle.tr(),
              padding: 0,
            ).paddingTop(40)
          else
            Wrap(
              spacing: 16,
              runSpacing: 20,
              children: data.services.map((service) {
                return SizedBox(
                  width: cardWidth,
                  child: UserServiceCard(service: service),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
