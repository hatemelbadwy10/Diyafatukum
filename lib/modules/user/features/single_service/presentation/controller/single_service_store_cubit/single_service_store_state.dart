part of 'single_service_store_cubit.dart';

class SingleServiceStoreState extends Equatable {
  const SingleServiceStoreState({
    required this.status,
    required this.items,
    required this.quantities,
    required this.totalPrice,
    this.service,
    this.store,
  });

  final CubitStatus<String> status;
  final UserHomeServiceModel? service;
  final SingleServiceProductModel? store;
  final List<SingleServiceStoreItemModel> items;
  final Map<String, int> quantities;
  final double totalPrice;

  factory SingleServiceStoreState.initial() {
    return SingleServiceStoreState(
      status: CubitStatus.initial(),
      items: const [],
      quantities: const {},
      totalPrice: 0,
    );
  }

  int quantityFor(String itemId) => quantities[itemId] ?? 0;

  int get selectedItemsCount => quantities.values.fold(0, (total, value) => total + value);

  bool get hasSelection => quantities.isNotEmpty;

  SingleServiceStoreState copyWith({
    CubitStatus<String>? status,
    UserHomeServiceModel? service,
    SingleServiceProductModel? store,
    List<SingleServiceStoreItemModel>? items,
    Map<String, int>? quantities,
    double? totalPrice,
  }) {
    return SingleServiceStoreState(
      status: status ?? this.status,
      service: service ?? this.service,
      store: store ?? this.store,
      items: items ?? this.items,
      quantities: quantities ?? this.quantities,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [
    status,
    service,
    store,
    items,
    quantities,
    totalPrice,
  ];
}
