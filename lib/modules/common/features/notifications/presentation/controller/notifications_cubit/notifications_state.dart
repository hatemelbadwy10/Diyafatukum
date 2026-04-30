part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({required this.status, required this.enabled});

  final CubitStatus status;
  final bool enabled;

  NotificationsState copyWith({CubitStatus? status, bool? enabled}) {
    return NotificationsState(
      status: status ?? this.status,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  List<Object> get props => [status, enabled];
}
