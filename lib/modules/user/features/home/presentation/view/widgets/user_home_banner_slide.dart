import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_image.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../data/model/user_home_model.dart';

class UserHomeBannerSlide extends StatelessWidget {
  const UserHomeBannerSlide({
    super.key,
    required this.banner,
  });

  final UserHomeBannerModel banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: 34.borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomImage.rounded(
            height: double.infinity,
            imageUrl: banner.imageUrl,
            radius: 34,
          ),
          Container(
            padding: 24.edgeInsetsAll,
            decoration: BoxDecoration(
              borderRadius: 34.borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Assets.images.logo.image(height: 62, fit: BoxFit.contain),
                const Spacer(),
                Text(
                  banner.title,
                  style: context.displayLarge.bold.s28
                      .setColor(context.onPrimary)
                      .setHeight(1.35),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                8.gap,
                Text(
                  banner.plainDescription,
                  style: context.bodyLarge.regular.s14
                      .setColor(context.onPrimary)
                      .setHeight(1.5),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                18.gap,
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomButton.stadium(
                    width: 142,
                    height: 50,
                    label: LocaleKeys.home_user_banner_action.tr(),
                    backgroundColor: context.scaffoldBackgroundColor,
                    fontColor: context.titleMedium.color,
                    borderRadius: 100,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
