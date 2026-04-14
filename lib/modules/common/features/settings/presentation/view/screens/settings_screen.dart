import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/menu_item_tile.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../profile/presentation/view/widgets/change_password_bottom_sheet.dart';
import '../../../data/model/settings_item_enum.dart';
import '../widgets/language_bottom_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.build(titleText: LocaleKeys.settings_title.tr()),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return Column(
            children: [
              VerticalListView(
                enableScroll: false,
                padding: EdgeInsets.zero,
                itemCount: SettingsItem.items(authState.status.isAuthorized).length,
                itemBuilder: (_, index) {
                  final settingItem = SettingsItem.items(authState.status.isAuthorized)[index];
                  return MenuItemTile(
                    enableBorder: true,
                    padding: 8.edgeInsetsAll,
                    iconBackgroundColor: context.primaryColor,
                    trailing: settingItem == SettingsItem.notification ? SizedBox.shrink() : null,
                    item: settingItem,
                    onTap: () {
                      if (settingItem == SettingsItem.language) {
                        context.showBottomSheet(const LanguageBottomSheet());
                      } else if (settingItem == SettingsItem.changePassword) {
                        context.showScrollableBottomSheet(body: ChangePasswordBottomSheet());
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ).withListView(padding: AppSize.screenPadding.edgeInsetsWithBottomNavBar),
    );
  }
}
