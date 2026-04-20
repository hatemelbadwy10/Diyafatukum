import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/user_home_model.dart';

class UserServiceCard extends StatelessWidget {
  const UserServiceCard({super.key, required this.service});

  final UserHomeServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 0.92,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: 26.borderRadius,
              image: DecorationImage(
                image: AssetImage(service.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child:
                Align(
                      alignment: AlignmentDirectional.bottomStart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: 10.borderRadius,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _serviceIcon.svg(
                              width: 16,
                              height: 16,
                              colorFilter: context.onPrimary.colorFilter,
                            ),
                            8.gap,
                            Text(
                              service.titleKey.tr(),
                              style: context.labelSmall.medium.s16,
                            ),
                          ],
                        ),
                      ),
                    )
                    .paddingAll(12)
                    .onTap(
                      () => AppRoutes.singleService.push(extra: service),
                      borderRadius: 26.borderRadius,
                    )
                    .setContainerToView(
                      borderWidth: 4,
                      borderColor: context.primarySwatch.shade100,
                      radius: 26,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.06),
                          Colors.black.withValues(alpha: 0.26),
                        ],
                      ),
                    ),
          ),
        ),

        12.gap,
        Text(
          LocaleKeys.home_user_shop_now.tr(),
          style: context.bodyLarge.regular.s16,
          textAlign: TextAlign.center,
        ),
      ],
    ).onTap(
      () => AppRoutes.singleService.push(extra: service),
      borderRadius: 26.borderRadius,
    );
  }

  SvgGenImage get _serviceIcon {
    switch (service.iconKey) {
      case 'gift':
        return Assets.icons.mdiGiftOutline;
      case 'camera':
        return Assets.icons.boxiconsCamera;
      case 'flowers':
        return Assets.icons.solarChairLinear;
      case 'beauty':
        return Assets.icons.iconoirProfileCircle;
      case 'coffee':
        return Assets.icons.letsIconsOrder;
      case 'sweets':
        return Assets.icons.iconoirBirthdayCake;
      case 'decorations':
        return Assets.icons.solarChairLinear;
      default:
        return Assets.icons.mdiGiftOutline;
    }
  }
}
