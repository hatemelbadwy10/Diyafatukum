import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_fallback_view.dart';
import '../../../../../../../core/widgets/custom_loading.dart';
import '../../../../../../../core/widgets/vertical_list_view.dart';
import '../../../data/model/notification_model.dart';
import '../../controller/notifications_cubit/notifications_cubit.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NotificationsCubit>().loadNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: CustomAppBar.build(
        titleText: LocaleKeys.notifications_title.tr(),
        titleStyle: context.displaySmall.bold.s18,
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final cubit = context.read<NotificationsCubit>();

          if (state.status.isLoading && state.notifications.isEmpty) {
            return const CustomLoading();
          }

          if (state.status.isFailed && state.notifications.isEmpty) {
            return CustomFallbackView(
              title: LocaleKeys.error_ops.tr(),
              subtitle: state.status.message,
              buttonLabel: LocaleKeys.actions_retry.tr(),
              onButtonPressed: cubit.loadNotifications,
            );
          }

          if (state.isEmpty) {
            return CustomFallbackView(
              icon: Assets.icons.cuidaNotificationBellOutline.svg(
                width: 72,
                height: 72,
                colorFilter: context.primaryColor.colorFilter,
              ),
              title: LocaleKeys.notifications_empty_title.tr(),
              subtitle: LocaleKeys.notifications_empty_subtitle.tr(),
            );
          }

          final sections = _buildSections(state.notifications);

          return VerticalListView(
            itemCount: sections.length,
            onRefresh: cubit.loadNotifications,
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.screenPadding,
              vertical: 20,
            ),
            separator: 24.gap,
            itemBuilder: (context, index) {
              final section = sections[index];
              return _NotificationSection(
                title: section.title,
                notifications: section.notifications,
                onNotificationTap: cubit.markNotificationAsRead,
              );
            },
          );
        },
      ),
    );
  }

  List<_NotificationSectionModel> _buildSections(
    List<NotificationModel> notifications,
  ) {
    final sortedNotifications = [...notifications]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final sections = <_NotificationSectionModel>[];

    for (final notification in sortedNotifications) {
      final sectionTitle = _sectionTitle(notification.createdAt);
      final sectionIndex = sections.indexWhere(
        (section) => section.title == sectionTitle,
      );

      if (sectionIndex == -1) {
        sections.add(
          _NotificationSectionModel(
            title: sectionTitle,
            notifications: [notification],
          ),
        );
        continue;
      }

      sections[sectionIndex] = sections[sectionIndex].copyWith(
        notifications: [...sections[sectionIndex].notifications, notification],
      );
    }

    return sections;
  }

  String _sectionTitle(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return LocaleKeys.details_date_time_today.tr();
    }
    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return LocaleKeys.details_date_time_yesterday.tr();
    }
    return date.format(format: 'd MMMM yyyy');
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection({
    required this.title,
    required this.notifications,
    required this.onNotificationTap,
  });

  final String title;
  final List<NotificationModel> notifications;
  final ValueChanged<NotificationModel> onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: context.greySwatch.shade200, thickness: 1),
            ),
            20.gap,
            Text(
              title,
              style: context.titleLarge.bold.s18.setColor(
                context.greySwatch.shade600,
              ),
            ),
          ],
        ),
        18.gap,
        ...notifications.map(
          (notification) => NotificationCard(
            notification: notification,
            timeLabel: _timeLabel(notification.createdAt),
            onTap: () => onNotificationTap(notification),
          ).paddingBottom(16),
        ),
      ],
    );
  }

  String _timeLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (_isSameDay(date, now)) {
      if (difference.inMinutes < 1) {
        return LocaleKeys.localized_elapsed_time_seconds.plural(0);
      }
      if (difference.inHours < 1) {
        return LocaleKeys.localized_elapsed_time_minutes.plural(
          difference.inMinutes,
          args: [difference.inMinutes.toString()],
        );
      }
      return LocaleKeys.localized_elapsed_time_hours.plural(
        difference.inHours,
        args: [difference.inHours.toString()],
      );
    }

    if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return LocaleKeys.details_date_time_yesterday.tr();
    }

    return date.format(format: 'd MMMM yyyy');
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class _NotificationSectionModel {
  const _NotificationSectionModel({
    required this.title,
    required this.notifications,
  });

  final String title;
  final List<NotificationModel> notifications;

  _NotificationSectionModel copyWith({
    String? title,
    List<NotificationModel>? notifications,
  }) {
    return _NotificationSectionModel(
      title: title ?? this.title,
      notifications: notifications ?? this.notifications,
    );
  }
}
