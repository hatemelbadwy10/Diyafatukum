part of 'provider_home_cubit.dart';

class ProviderHomeState extends Equatable {
  const ProviderHomeState({
    required this.status,
    required this.home,
    required this.orders,
  });

  final CubitStatus<ProviderHomeModel> status;
  final ProviderHomeModel? home;
  final List<ProviderHomeOrderModel> orders;

  factory ProviderHomeState.initial() {
    return ProviderHomeState(
      status: CubitStatus.initial(),
      home: null,
      orders: const [],
    );
  }

  ProviderHomeState copyWith({
    CubitStatus<ProviderHomeModel>? status,
    ProviderHomeModel? home,
    List<ProviderHomeOrderModel>? orders,
  }) {
    return ProviderHomeState(
      status: status ?? this.status,
      home: home ?? this.home,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [status, home, orders];
}
