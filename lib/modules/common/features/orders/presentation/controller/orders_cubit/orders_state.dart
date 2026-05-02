part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  const OrdersState({
    required this.status,
    required this.orders,
    required this.selectedStatus,
  });

  final CubitStatus<void> status;
  final List<OrderModel> orders;
  final OrderTabStatus selectedStatus;

  factory OrdersState.initial() {
    return OrdersState(
      status: CubitStatus.initial(),
      orders: const [],
      selectedStatus: OrderTabStatus.current,
    );
  }

  List<OrderModel> byStatus(OrderTabStatus status) {
    return orders.where((order) => order.tabStatus == status).toList();
  }

  OrdersState copyWith({
    CubitStatus<void>? status,
    List<OrderModel>? orders,
    OrderTabStatus? selectedStatus,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [status, orders, selectedStatus];
}
