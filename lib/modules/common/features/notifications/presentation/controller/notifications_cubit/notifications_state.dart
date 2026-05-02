part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    required this.status,
    required this.enabled,
    required this.notifications,
  });

  final CubitStatus status;
  final bool enabled;
  final List<NotificationModel> notifications;

  bool get isEmpty => notifications.isEmpty;

  NotificationsState copyWith({
    CubitStatus? status,
    bool? enabled,
    List<NotificationModel>? notifications,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      enabled: enabled ?? this.enabled,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [status, enabled, notifications];
}
