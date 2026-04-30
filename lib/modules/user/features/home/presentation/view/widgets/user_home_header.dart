import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../common/features/auth/data/repository/auth_repository.dart';
import '../../../../../../common/features/profile/data/model/user_model.dart';
import 'notification_button.dart';
import 'profile_button.dart';

class UserHomeHeader extends StatelessWidget {
  const UserHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = sl<AuthRepository>().getAuthData()?.user ?? const UserModel.guest();
    final userName = user.id == 0 ? user.name.tr() : user.name;
    final deliveryLocation = user.address?.area.isNotEmpty == true
        ? user.address!.area
        : user.address?.fullAddress.isNotEmpty == true
            ? user.address!.fullAddress
            : user.addressText.isNotEmpty
                ? user.addressText
                : LocaleKeys.home_user_delivery_default.tr();

    return Row(
      children: [
        const ProfileButton(),
        12.gap,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.home_user_greeting.tr(args: [userName]),
                style: context.titleSmall.semiBold.s18,
                textAlign: TextAlign.start,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              4.gap,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    LocaleKeys.home_user_delivery_to.tr(args: [deliveryLocation]),
                    style: context.bodyLarge.regular.s14,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).flexible(),
                  4.gap,
                  Assets.icons.dropdownArrow.path.toSvg(
                    color: context.titleSmall.color,
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ],
          ),
        ),
        12.gap,
        const NotificationButton(),
      ],
    );
  }
}
