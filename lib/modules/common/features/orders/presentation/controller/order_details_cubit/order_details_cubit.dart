import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/utils/notifications.dart';
import '../../../../notifications/data/model/push_notification_model.dart';
import '../../../data/model/order_model.dart';
import '../../../data/repository/orders_repository.dart';

part 'order_details_state.dart';

@injectable
class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  OrderDetailsCubit(this._repository) : super(OrderDetailsState.initial()) {
    _notificationSubscription = RemoteNotificationServices.orderNotifications
        .where(
          (notification) =>
              notification.type == PushNotificationType.orderStatusUpdated,
        )
        .listen(_handleOrderNotification);
  }

  final OrdersRepository _repository;
  late final StreamSubscription<PushNotificationModel>
  _notificationSubscription;
  String? _orderId;

  void initialize({required String orderId, OrderModel? initialOrder}) {
    _orderId = orderId;
    if (initialOrder != null) {
      emit(state.copyWith(status: CubitStatus.success(data: initialOrder)));
    }
    unawaited(getOrderDetails());
  }

  Future<void> _handleOrderNotification(
    PushNotificationModel notification,
  ) async {
    if (notification.orderId == _orderId) {
      await getOrderDetails();
    }
  }

  Future<void> getOrderDetails() async {
    final orderId = _orderId;
    if (orderId == null || orderId.isEmpty) return;

    emit(state.copyWith(status: CubitStatus.loading(data: state.status.data)));
    final result = await _repository.getOrderDetails(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(
            data: state.status.data,
            message: failure.message,
            error: failure,
          ),
        ),
      ),
      (response) {
        final order = response.data;
        if (order == null) {
          emit(
            state.copyWith(
              status: CubitStatus.failed(
                data: state.status.data,
                message: response.message ?? '',
              ),
            ),
          );
          return;
        }
        emit(state.copyWith(status: CubitStatus.success(data: order)));
      },
    );
  }

  void updateOrder(OrderModel order) {
    emit(state.copyWith(status: CubitStatus.success(data: order)));
  }

  @override
  Future<void> close() async {
    await _notificationSubscription.cancel();
    return super.close();
  }
}
