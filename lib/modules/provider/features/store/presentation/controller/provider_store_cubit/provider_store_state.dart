part of 'provider_store_cubit.dart';

class ProviderStoreState extends Equatable {
  const ProviderStoreState({
    required this.status,
    required this.store,
    required this.products,
    required this.selectedCategoryId,
  });

  final CubitStatus<ProviderStoreModel> status;
  final ProviderStoreModel? store;
  final List<ProviderStoreProductModel> products;
  final String selectedCategoryId;

  factory ProviderStoreState.initial() {
    return ProviderStoreState(
      status: CubitStatus.initial(),
      store: null,
      products: [],
      selectedCategoryId: 'all',
    );
  }

  List<ProviderStoreProductModel> get visibleProducts {
    if (selectedCategoryId == 'all') {
      return products;
    }
    return products.where((product) => product.categoryId == selectedCategoryId).toList();
  }

  bool get isEmpty => visibleProducts.isEmpty;

  ProviderStoreState copyWith({
    CubitStatus<ProviderStoreModel>? status,
    ProviderStoreModel? store,
    List<ProviderStoreProductModel>? products,
    String? selectedCategoryId,
  }) {
    return ProviderStoreState(
      status: status ?? this.status,
      store: store ?? this.store,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [status, store, products, selectedCategoryId];
}
