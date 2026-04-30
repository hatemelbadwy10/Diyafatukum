part of 'single_service_store_cubit.dart';

class SingleServiceStoreState extends Equatable {
  const SingleServiceStoreState({
    required this.status,
    required this.items,
    required this.filteredItems,
    required this.categories,
    required this.quantities,
    required this.totalPrice,
    this.selectedCategoryId,
    this.storeDetails,
    this.service,
    this.store,
  });

  final CubitStatus<String> status;
  final SingleServiceStoreDetailsModel? storeDetails;
  final UserHomeServiceModel? service;
  final SingleServiceProductModel? store;
  final List<SingleServiceStoreItemModel> items;
  final List<SingleServiceStoreItemModel> filteredItems;
  final List<SingleServiceStoreCategoryModel> categories;
  final String? selectedCategoryId;
  final Map<String, int> quantities;
  final double totalPrice;

  factory SingleServiceStoreState.initial() {
    return SingleServiceStoreState(
      status: CubitStatus.initial(),
      items: const [],
      filteredItems: const [],
      categories: const [],
      quantities: const {},
      totalPrice: 0,
    );
  }

  int quantityFor(String itemId) => quantities[itemId] ?? 0;

  int get selectedItemsCount =>
      quantities.values.fold(0, (total, value) => total + value);

  bool get hasSelection => quantities.isNotEmpty;

  SingleServiceStoreState copyWith({
    CubitStatus<String>? status,
    SingleServiceStoreDetailsModel? storeDetails,
    UserHomeServiceModel? service,
    SingleServiceProductModel? store,
    List<SingleServiceStoreItemModel>? items,
    List<SingleServiceStoreItemModel>? filteredItems,
    List<SingleServiceStoreCategoryModel>? categories,
    String? selectedCategoryId,
    Map<String, int>? quantities,
    double? totalPrice,
  }) {
    return SingleServiceStoreState(
      status: status ?? this.status,
      storeDetails: storeDetails ?? this.storeDetails,
      service: service ?? this.service,
      store: store ?? this.store,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      quantities: quantities ?? this.quantities,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  @override
  List<Object?> get props => [
    status,
    storeDetails,
    service,
    store,
    items,
    filteredItems,
    categories,
    selectedCategoryId,
    quantities,
    totalPrice,
  ];
}
