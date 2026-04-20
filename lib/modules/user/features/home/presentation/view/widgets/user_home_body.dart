import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_search_field.dart';
import '../../../data/model/user_home_model.dart';
import 'user_home_banner.dart';
import 'user_home_featured_section.dart';
import 'user_home_header.dart';
import 'user_service_card.dart';

class UserHomeBody extends StatelessWidget {
  const UserHomeBody({super.key, required this.data});

  final UserHomeModel data;

  @override
  Widget build(BuildContext context) {
    final cardWidth = (context.width - (AppSize.screenPadding * 2) - 16) / 2;
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
            hintText: data.searchHintKey.tr(),
            readOnly: false,
            onTap: () {},
          ),
          24.gap,
          UserHomeBanner(data: data),
          32.gap,
          UserHomeFeaturedSection(
            titleKey: data.featuredTitleKey,
            subtitleKey: data.featuredSubtitleKey,
          ),
          24.gap,
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
