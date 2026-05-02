import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/notification_model.dart';
import '../../../data/repository/notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository, bool initialEnabled)
    : super(
        NotificationsState(
          status: CubitStatus.initial(),
          enabled: initialEnabled,
          notifications: const [],
        ),
      );

  final NotificationsRepository _repository;

  Future<void> loadNotifications() async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getNotifications();
    response.fold(
      (failure) => emit(
        state.copyWith(status: CubitStatus.failed(message: failure.message)),
      ),
      (data) => emit(
        state.copyWith(
          status: CubitStatus.success(),
          notifications: data.data ?? const [],
        ),
      ),
    );
  }

  Future<void> updateSettings(bool enabled) async {
    emit(state.copyWith(status: CubitStatus.loading(), enabled: enabled));
    final response = await _repository.updateSettings(enabled);
    response.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message),
          enabled: !enabled,
        ),
      ),
      (_) =>
          emit(state.copyWith(status: CubitStatus.success(), enabled: enabled)),
    );
  }

  Future<void> markNotificationAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    final previousNotifications = state.notifications;
    final updatedNotifications = previousNotifications
        .map(
          (item) => item.id == notification.id
              ? item.copyWith(isRead: true, readAt: DateTime.now())
              : item,
        )
        .toList();

    emit(state.copyWith(notifications: updatedNotifications));

    final response = await _repository.markAsRead(notification.id);
    response.fold(
      (_) => emit(state.copyWith(notifications: previousNotifications)),
      (_) {},
    );
  }
}
