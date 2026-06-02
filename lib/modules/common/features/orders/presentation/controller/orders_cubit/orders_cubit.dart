import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/error/failure.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';
import '../../../data/repository/orders_repository.dart';

part 'orders_state.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(OrdersState.initial());

  final OrdersRepository _repository;

  void _emitIfOpen(OrdersState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> loadOrders([
    OrderTabStatus status = OrderTabStatus.current,
  ]) async {
    _emitIfOpen(
      state.copyWith(status: CubitStatus.loading(), selectedStatus: status),
    );

    final result = await _repository.getOrders(status);
    if (isClosed) return;

    result.fold(
      (failure) => _emitIfOpen(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message, error: failure),
          selectedStatus: status,
        ),
      ),
      (response) {
        final loadedOrders = response.data ?? const <OrderModel>[];
        final orders = <OrderModel>[
          ...state.orders.where((order) => order.tabStatus != status),
          ...loadedOrders,
        ];

        _emitIfOpen(
          state.copyWith(
            status: CubitStatus.success(),
            orders: orders,
            selectedStatus: status,
          ),
        );
      },
    );
  }

  Future<void> cancelOrder({required String id, required String reason}) async {
    _emitIfOpen(state.copyWith(cancelStatus: CubitStatus.loading()));

    final result = await _repository.cancelOrder(id, reason);
    if (isClosed) return;

    result.fold(
      (failure) => _emitIfOpen(
        state.copyWith(
          cancelStatus: CubitStatus.failed(
            message: failure.message,
            error: failure,
          ),
        ),
      ),
      (_) {
        final orders = state.orders.map((order) {
          if (order.backendId != id) return order;
          return order.copyWith(
            tabStatus: OrderTabStatus.cancelled,
            activeStatus: OrderTimelineStatus.cancelled,
            cancellationReason: reason,
            timeline: const [
              OrderTimelineStep(
                status: OrderTimelineStatus.cancelled,
                label: '',
                completed: true,
                current: true,
              ),
            ],
          );
        }).toList();

        _emitIfOpen(
          state.copyWith(
            orders: orders,
            cancelStatus: CubitStatus.success(
              message: LocaleKeys.orders_details_actions_cancel_success.tr(),
            ),
          ),
        );
      },
    );
  }

  Future<Failure?> acceptProviderOrder(String id) async {
    final result = await _repository.acceptProviderOrder(id);
    if (isClosed) return null;

    return result.fold((failure) => failure, (_) {
      _updateOrder(id, (order) => order.markProviderAccepted());
      return null;
    });
  }

  Future<Failure?> rejectProviderOrder({
    required String id,
    required String reason,
  }) async {
    final result = await _repository.rejectProviderOrder(id, reason);
    if (isClosed) return null;

    return result.fold((failure) => failure, (_) {
      _updateOrder(id, (order) => order.markProviderRejected(reason));
      return null;
    });
  }

  Future<Failure?> advanceProviderOrderStatus({
    required String id,
    required OrderTimelineStatus status,
  }) async {
    final result = await _repository.advanceProviderOrderStatus(
      id,
      status.value,
    );
    if (isClosed) return null;

    return result.fold((failure) => failure, (_) {
      _updateOrder(id, (order) => order.markProviderAdvanced(status));
      return null;
    });
  }

  void _updateOrder(String id, OrderModel Function(OrderModel order) update) {
    final orders = state.orders.map((order) {
      if (order.backendId != id) return order;
      return update(order);
    }).toList();

    _emitIfOpen(state.copyWith(orders: orders));
  }
}
