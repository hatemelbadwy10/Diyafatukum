import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/app_dialog.dart';
import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../notifications/presentation/controller/notifications_cubit/notifications_cubit.dart';
import '../../../../shared/presentation/view/widgets/login_dialog.dart';
import '../../../data/model/static_page_enum.dart';
import '../widgets/language_bottom_sheet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authCubit = context.maybeRead<AuthCubit>();
    final isAuthorized = authCubit?.state.status.isAuthorized ?? false;

    void showGuestDialog() {
      LoginDialog(message: LocaleKeys.auth_guest_login_hint.tr()).show(context);
    }

    return BlocProvider(
      create: (_) => NotificationsCubit(
        sl(),
        authCubit?.state.user.notificationEnabled ?? false,
      ),
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        body: BlocConsumer<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state.status.isSuccess && authCubit != null) {
              authCubit.updateUserData(
                authCubit.state.user.copyWith(
                  notificationEnabled: state.enabled,
                ),
              );
            }
          },
          builder: (context, notificationState) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  64.gap,
                  Assets.images.logo.image(height: 100).center(),
                  24.gap,
                  // if (isAuthorized)
                  _SectionTitle(
                    title: LocaleKeys.settings_sections_account.tr(),
                  ),
                  16.gap,
                  _SettingsActionTile(
                    title: LocaleKeys.settings_edit_profile.tr(),
                    icon: Assets.icons.iconoirProfileCircle.path,
                    onTap: isAuthorized
                        ? () => AppRoutes.profile.push()
                        : showGuestDialog,
                  ),
                  _SettingsToggleTile(
                    title: LocaleKeys.notifications_title.tr(),
                    icon: Assets.icons.cuidaNotificationBellOutline.path,
                    value: notificationState.enabled,
                    onChanged: isAuthorized
                        ? (value) => context
                              .read<NotificationsCubit>()
                              .updateSettings(value)
                        : null,
                    onTap: isAuthorized ? null : showGuestDialog,
                  ),
                  24.gap,

                  _SectionTitle(
                    title: LocaleKeys.settings_sections_general.tr(),
                  ),
                  16.gap,
                  _SettingsActionTile(
                    title: LocaleKeys.settings_language_title.tr(),
                    icon: Assets.icons.materialSymbolsLightLanguage.path,
                    onTap: () =>
                        context.showBottomSheet(const LanguageBottomSheet()),
                  ),
                  _SettingsActionTile(
                    title: LocaleKeys.settings_about.tr(),
                    icon: Assets.icons.materialSymbolsInfoOutlineRounded.path,
                    onTap: () =>
                        AppRoutes.staticPage.push(extra: StaticPage.about),
                  ),
                  _SettingsActionTile(
                    title: LocaleKeys.settings_refund_policy.tr(),
                    icon: Assets.icons.boxiconsUndo.path,
                    onTap: () => AppRoutes.staticPage.push(
                      extra: StaticPage.cancellationRefund,
                    ),
                  ),
                  _SettingsActionTile(
                    title: LocaleKeys.settings_support.tr(),
                    icon: Assets.icons.component6.path,
                    onTap: () => AppRoutes.contact.push(),
                  ),
                  _SettingsActionTile(
                    title: LocaleKeys.settings_privacy.tr(),
                    icon: Assets.icons.weuiLockOutlined.path,
                    onTap: () =>
                        AppRoutes.staticPage.push(extra: StaticPage.privacy),
                  ),
                  _SettingsActionTile(
                    title: LocaleKeys.settings_terms.tr(),
                    icon: Assets.icons.iconParkOutlineTransactionOrder.path,
                    onTap: () =>
                        AppRoutes.staticPage.push(extra: StaticPage.terms),
                  ),
                  if (isAuthorized)
                    _SettingsActionTile(
                      title: LocaleKeys.account_profile_logout_title.tr(),
                      icon: Assets.icons.streamlineLogout1.path,
                      isDestructive: true,
                      showArrow: false,
                      onTap: () {
                        AppDialog(
                          onConfirm: () {
                            authCubit?.logout();
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
                      },
                    ),
                ],
              ).withListView(
                padding: AppSize.screenPadding.edgeInsetsWithBottomNavBar,
              ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.titleLarge.regular.setColor(context.colorScheme.onSurface),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.title,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
    this.showArrow = true,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.edgeInsetsVertical,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.greySwatch.shade100)),
      ),
      child: Row(
        children: [
          icon
              .toSvg(
                width: 28,
                height: 28,
                color: isDestructive
                    ? context.errorColor
                    : context.primaryColor,
              )
              .setContainerToView(
                color: isDestructive
                    ? context.errorColor.withValues(alpha: 0.08)
                    : context.primaryColor.withValues(alpha: 0.08),
                radius: 22,
                padding: 10,
              ),
          if (showArrow)
            if (showArrow) 12.gap,
          Text(
            title,
            style: context.titleMedium.regular.setColor(
              isDestructive
                  ? context.errorColor
                  : context.colorScheme.onSurface,
            ),
          ).expand(),
          12.gap,
          Transform.flip(
            flipX: true,
            child: Assets.icons.icon.svg(
              height: 22,
              colorFilter: context.greySwatch.shade400.colorFilter,
            ),
          ),
        ],
      ),
    ).onTap(onTap, borderRadius: 12.borderRadius);
  }
}

class _SettingsToggleTile extends StatelessWidget {
  const _SettingsToggleTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.onTap,
  });

  final String title;
  final String icon;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: 14.edgeInsetsVertical,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.greySwatch.shade100)),
      ),
      child: Row(
        children: [
          icon
              .toSvg(width: 28, height: 28, color: context.primaryColor)
              .setContainerToView(
                color: context.primaryColor.withValues(alpha: 0.08),
                radius: 22,
                padding: 10,
              ),
          12.gap,
          Text(
            title,
            style: context.titleMedium.regular.setColor(
              context.colorScheme.onSurface,
            ),
          ).expand(),
          12.gap,

          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: context.primaryColor,
            activeTrackColor: context.primaryColor.withValues(alpha: 0.35),
            inactiveThumbColor: context.scaffoldBackgroundColor,
            inactiveTrackColor: context.greySwatch.shade300,
          ),
        ],
      ),
    ).onTap(onTap, borderRadius: 12.borderRadius);
  }
}
