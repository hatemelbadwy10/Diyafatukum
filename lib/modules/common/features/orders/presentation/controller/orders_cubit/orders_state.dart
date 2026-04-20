part of 'orders_cubit.dart';

class OrdersState extends Equatable {
  const OrdersState({
    required this.status,
    required this.orders,
  });

  final CubitStatus<void> status;
  final List<OrderModel> orders;

  factory OrdersState.initial() {
    return OrdersState(
      status: CubitStatus.initial(),
      orders: const [],
    );
  }

  List<OrderModel> byStatus(OrderTabStatus status) {
    return orders.where((order) => order.tabStatus == status).toList();
  }

  OrdersState copyWith({
    CubitStatus<void>? status,
    List<OrderModel>? orders,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [status, orders];
}
