import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';

import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/widgets/profile_avatar.dart';
import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../shared/presentation/view/widgets/login_dialog.dart';
import 'greeting_widget.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.onAvatarChanged});
  final void Function(File)? onAvatarChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return Row(
          children: [
            ProfileAvatar(
              size: 56,
              onChanged: onAvatarChanged,
              name: user.name.tr(),
              onTap: () {
                if (state.status.isAuthorized) {
                  AppRoutes.profile.push();
                } else {
                  LoginDialog(message: LocaleKeys.account_guest.tr()).show(context);
                }
              },
            ),
            16.gap,
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             //   GreetingWidget(),
                state.status.build(
                  onAuthorized: Text(
                    user.name.capitalizeFirstOfEach,
                    style: context.labelSmall.regular.s16.setColor(context.onPrimary),
                  ),
                  onUnauthorized: CustomTextButton(
                    label: LocaleKeys.auth_guest_login.tr(),
                    onPressed: () => AppRoutes.login.push(),
                    textStyle: context.labelSmall.regular.s12.setColor(context.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
