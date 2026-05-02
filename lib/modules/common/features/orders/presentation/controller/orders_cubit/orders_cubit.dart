import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/order_model.dart';
import '../../../data/repository/orders_repository.dart';

part 'orders_state.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(OrdersState.initial());

  final OrdersRepository _repository;

  Future<void> loadOrders([
    OrderTabStatus status = OrderTabStatus.current,
  ]) async {
    emit(state.copyWith(status: CubitStatus.loading(), selectedStatus: status));

    final result = await _repository.getOrders(status);

    result.fold(
      (failure) => emit(
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

        emit(
          state.copyWith(
            status: CubitStatus.success(),
            orders: orders,
            selectedStatus: status,
          ),
        );
      },
    );
  }
}
