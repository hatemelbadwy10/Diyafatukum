part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  const OrdersState({
    required this.status,
    required this.cancelStatus,
    required this.orders,
    required this.selectedStatus,
  });

  final CubitStatus<void> status;
  final CubitStatus<void> cancelStatus;
  final List<OrderModel> orders;
  final OrderTabStatus selectedStatus;

  factory OrdersState.initial() {
    return OrdersState(
      status: CubitStatus.initial(),
      cancelStatus: CubitStatus.initial(),
      orders: const [],
      selectedStatus: OrderTabStatus.current,
    );
  }

  List<OrderModel> byStatus(OrderTabStatus status) {
    return orders.where((order) => order.tabStatus == status).toList();
  }

  OrderModel? findOrder(String backendId) {
    for (final order in orders) {
      if (order.backendId == backendId) {
        return order;
      }
    }
    return null;
  }

  OrdersState copyWith({
    CubitStatus<void>? status,
    CubitStatus<void>? cancelStatus,
    List<OrderModel>? orders,
    OrderTabStatus? selectedStatus,
  }) {
    return OrdersState(
      status: status ?? this.status,
      cancelStatus: cancelStatus ?? this.cancelStatus,
      orders: orders ?? this.orders,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [status, cancelStatus, orders, selectedStatus];
}
