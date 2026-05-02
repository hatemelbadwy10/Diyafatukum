import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../common/features/auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../../../common/features/shared/presentation/view/widgets/login_dialog.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Assets.icons.cuidaNotificationBellOutline.path
            .toSvg(color: context.primaryColor, width: 100, height: 100)
            .onTap(() {
              if (authState.status.isGuest) {
                LoginDialog().show(context);
                return;
              }
              AppRoutes.notifications.push();
            }, borderRadius: 28.borderRadius)
            .setContainerToView(
              radius: 80,
              color: context.greySwatch.shade100,
              width: 56,
              height: 56,
            ),
        PositionedDirectional(
          top: 12,
          end: 14,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: context.errorColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.scaffoldBackgroundColor,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
