import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/provider_store_model.dart';
import '../../../data/repository/provider_store_repository.dart';

part 'provider_store_state.dart';

@injectable
class ProviderStoreCubit extends Cubit<ProviderStoreState> {
  ProviderStoreCubit(this._repository) : super(ProviderStoreState.initial());

  final ProviderStoreRepository _repository;

  Future<void> loadStore() async {
    emit(state.copyWith(status: CubitStatus.loading()));

    final result = await _repository.getStore();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message, error: failure),
        ),
      ),
      (response) {
        final store = response.data;
        emit(
          state.copyWith(
            status: CubitStatus.success(data: store),
            store: store,
            products: store?.products ?? const [],
            selectedCategoryId: store != null && store.categories.isNotEmpty
                ? store.categories.first.id
                : 'all',
          ),
        );
      },
    );
  }

  void selectCategory(String categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  void deleteProduct(String productId) {
    final updatedProducts = state.products.where((product) => product.id != productId).toList();
    emit(
      state.copyWith(
        products: updatedProducts,
        store: state.store?.copyWith(products: updatedProducts),
      ),
    );
  }

  void updateStoreDetails({
    required String nameAr,
    required String nameEn,
    required String category,
    required String location,
    required String whatsapp,
    String? coverImagePath,
  }) {
    final store = state.store;
    if (store == null) return;

    emit(
      state.copyWith(
        store: store.copyWith(
          name: nameAr,
          nameEn: nameEn,
          category: category,
          location: location,
          whatsapp: whatsapp,
          coverImagePath: coverImagePath ?? store.coverImagePath,
        ),
      ),
    );
  }

  void updateAbout(String description) {
    final store = state.store;
    if (store == null) return;

    emit(state.copyWith(store: store.copyWith(aboutDescription: description)));
  }

  void addCategory(String categoryName) {
    final store = state.store;
    if (store == null) return;

    final categoryId = categoryName.toLowerCase().replaceAll(' ', '_');
    final newCategory = ProviderStoreCategoryModel(id: categoryId, name: categoryName);
    final updatedCategories = [...store.categories, newCategory];

    emit(
      state.copyWith(
        store: store.copyWith(categories: updatedCategories),
      ),
    );
  }

  void addProduct({
    required String name,
    required double price,
    required String categoryId,
    required String imagePath,
  }) {
    final store = state.store;
    if (store == null) return;

    final product = ProviderStoreProductModel(
      id: '${categoryId}_${DateTime.now().microsecondsSinceEpoch}',
      categoryId: categoryId,
      name: name,
      price: price,
      imagePath: imagePath,
    );
    final updatedProducts = [...state.products, product];

    emit(
      state.copyWith(
        products: updatedProducts,
        selectedCategoryId: categoryId,
        store: store.copyWith(products: updatedProducts),
      ),
    );
  }
}
