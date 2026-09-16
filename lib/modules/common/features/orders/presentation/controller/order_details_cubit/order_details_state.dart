part of 'order_details_cubit.dart';

class OrderDetailsState extends Equatable {
  const OrderDetailsState({required this.status});

  final CubitStatus<OrderModel> status;

  factory OrderDetailsState.initial() =>
      OrderDetailsState(status: CubitStatus.initial());

  OrderDetailsState copyWith({CubitStatus<OrderModel>? status}) {
    return OrderDetailsState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
