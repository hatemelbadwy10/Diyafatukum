import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/repository/notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository, bool initialEnabled)
    : super(
        NotificationsState(
          status: CubitStatus.initial(),
          enabled: initialEnabled,
        ),
      );

  final NotificationsRepository _repository;

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
}
