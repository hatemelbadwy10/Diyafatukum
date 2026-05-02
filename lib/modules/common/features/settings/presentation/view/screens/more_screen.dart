import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/app_dialog.dart';
import '../../../../../../../core/widgets/menu_item_tile.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../data/model/more_menu_item_enum.dart';
import '../widgets/social_contacts_section.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return VerticalListView(
                enableScroll: false,
                padding: EdgeInsets.zero,
                itemCount: MoreMenuItem.items(state.status.isAuthorized).length,
                itemBuilder: (_, index) {
                  final menuItem = MoreMenuItem.items(
                    state.status.isAuthorized,
                  )[index];
                  return MenuItemTile(
                    enableBorder: true,
                    padding: 8.edgeInsetsAll,
                    item: menuItem,
                    iconBackgroundColor: context.primaryColor,
                    isDestructive: menuItem.isDestructive,
                    trailing: menuItem.isLogout ? SizedBox.shrink() : null,
                    onTap: () {
                      if (menuItem.isLogout) {
                        AppDialog(
                          onConfirm: () {
                            context.read<AuthCubit>().logout();
                            AppRoutes.onboarding.go();
                          },
                          title: LocaleKeys.account_profile_logout_title.tr(),
                          subtitle: LocaleKeys.account_profile_logout_subtitle
                              .tr(),
                          confirmLabel: LocaleKeys.actions_confirm.tr(),
                          cancelLabel: LocaleKeys.actions_cancel.tr(),
                          confirmDestructive: true,
                          icon: Icon(
                            Icons.logout_rounded,
                            color: context.onPrimary,
                            size: 28,
                          ),
                        ).show(context);
                      }
                    },
                  );
                },
              );
            },
          ),
          24.gap,
          SocialContactsSection(),
        ],
      ).withListView(padding: AppSize.screenPadding.edgeInsetsWithBottomNavBar),
    );
  }
}
