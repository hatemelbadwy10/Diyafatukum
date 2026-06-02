import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/error/failure.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/provider_store_model.dart';
import '../../../data/model/provider_store_request_model.dart';
import '../../../data/repository/provider_store_repository.dart';

part 'provider_store_state.dart';

@injectable
class ProviderStoreCubit extends Cubit<ProviderStoreState> {
  ProviderStoreCubit(this._repository) : super(ProviderStoreState.initial());

  final ProviderStoreRepository _repository;

  Future<void> loadStore({
    bool showLoading = true,
    String? preserveSelectedCategoryId,
  }) async {
    if (showLoading) {
      emit(state.copyWith(status: CubitStatus.loading()));
    }

    final result = await _repository.getStore();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message, error: failure),
        ),
      ),
      (response) {
        final store = response.data;
        final selectedCategoryId =
            preserveSelectedCategoryId ??
            (store != null &&
                    store.categories.any(
                      (category) => category.id == state.selectedCategoryId,
                    )
                ? state.selectedCategoryId
                : 'all');
        emit(
          state.copyWith(
            status: CubitStatus.success(data: store),
            store: store,
            products: store?.products ?? const [],
            selectedCategoryId: selectedCategoryId,
          ),
        );
      },
    );

    final selectedCategoryId =
        preserveSelectedCategoryId ?? state.selectedCategoryId;
    if (selectedCategoryId != 'all') {
      await selectCategory(selectedCategoryId);
    }
  }

  Future<void> selectCategory(String categoryId) async {
    emit(state.copyWith(selectedCategoryId: categoryId));
    final result = await _repository.getProducts(
      categoryId: categoryId == 'all' ? null : categoryId,
    );
    result.fold(
      (_) {},
      (response) => emit(state.copyWith(products: response.data ?? const [])),
    );
  }

  Future<Failure?> deleteProduct(String productId) async {
    final result = await _repository.deleteProduct(productId);
    return result.fold((failure) => failure, (_) {
      final updatedProducts = state.products
          .where((product) => product.id != productId)
          .toList();
      emit(
        state.copyWith(
          products: updatedProducts,
          store: state.store?.copyWith(products: updatedProducts),
        ),
      );
      return null;
    });
  }

  Future<Failure?> updateStoreDetails(
    ProviderStoreUpdateRequestModel request,
  ) async {
    final result = await _repository.updateStore(request);
    return result.fold((failure) => failure, (_) {
      final store = state.store;
      if (store != null) {
        emit(
          state.copyWith(
            store: request.applyToStore(store),
            status: CubitStatus.success(data: request.applyToStore(store)),
          ),
        );
      }
      return null;
    });
  }

  Future<Failure?> updateAbout(
    ProviderStoreDescriptionRequestModel request,
  ) async {
    final result = await _repository.updateStoreDescription(request);
    return result.fold((failure) => failure, (_) {
      final store = state.store;
      if (store != null) {
        emit(
          state.copyWith(
            store: request.applyToStore(store),
            status: CubitStatus.success(data: request.applyToStore(store)),
          ),
        );
      }
      return null;
    });
  }

  Future<Failure?> addCategory(
    ProviderStoreCategoryRequestModel request,
  ) async {
    final result = await _repository.createCategory(request);
    return result.fold((failure) => failure, (_) {
      final store = state.store;
      if (store != null) {
        final createdCategory = request.toCategory(
          id: 'local_${DateTime.now().millisecondsSinceEpoch}',
        );
        final updatedCategories = [
          ...store.categories,
          createdCategory,
        ];
        final updatedStore = store.copyWith(categories: updatedCategories);
        emit(
          state.copyWith(
            store: updatedStore,
            status: CubitStatus.success(data: updatedStore),
          ),
        );
      }
      return null;
    });
  }

  Future<Failure?> addProduct(ProviderStoreProductRequestModel request) async {
    final result = await _repository.createProduct(request);
    return result.fold((failure) => failure, (_) {
      final store = state.store;
      if (store != null) {
        final categoryName = _categoryNameById(request.storeCategoryId);
        final createdProduct = request.toProduct(
          id: 'local_${DateTime.now().millisecondsSinceEpoch}',
          categoryName: categoryName,
          imagePath: request.image?.path ?? '',
        );
        final updatedProducts = _nextProductsAfterUpsert(
          product: createdProduct,
          previousProductId: null,
        );
        final updatedStore = store.copyWith(products: updatedProducts);
        emit(
          state.copyWith(
            products: updatedProducts,
            store: updatedStore,
            status: CubitStatus.success(data: updatedStore),
          ),
        );
      }
      return null;
    });
  }

  Future<Failure?> updateProduct(
    String productId,
    ProviderStoreProductRequestModel request,
  ) async {
    final result = await _repository.updateProduct(productId, request);
    return result.fold((failure) => failure, (_) {
      final store = state.store;
      if (store != null) {
        final previousProduct = state.products.firstWhere(
          (product) => product.id == productId,
          orElse: () => request.toProduct(
            id: productId,
            categoryName: _categoryNameById(request.storeCategoryId),
            imagePath: request.image?.path ?? '',
          ),
        );
        final updatedProduct = request.toProduct(
          id: productId,
          categoryName: _categoryNameById(request.storeCategoryId),
          imagePath: request.image?.path ?? previousProduct.imagePath,
        );
        final updatedProducts = _nextProductsAfterUpsert(
          product: updatedProduct,
          previousProductId: previousProduct.id,
        );
        final updatedStore = store.copyWith(products: updatedProducts);
        emit(
          state.copyWith(
            products: updatedProducts,
            store: updatedStore,
            status: CubitStatus.success(data: updatedStore),
          ),
        );
      }
      return null;
    });
  }

  List<ProviderStoreProductModel> _nextProductsAfterUpsert({
    required ProviderStoreProductModel product,
    required String? previousProductId,
  }) {
    final filteredProducts = state.products
        .where((item) => item.id != previousProductId)
        .toList();

    if (state.selectedCategoryId == 'all' ||
        state.selectedCategoryId == product.categoryId) {
      return [product, ...filteredProducts];
    }

    return filteredProducts;
  }

  String _categoryNameById(String categoryId) {
    return state.store?.categories
            .firstWhere(
              (category) => category.id == categoryId,
              orElse: () => const ProviderStoreCategoryModel(id: '', name: ''),
            )
            .name ??
        '';
  }
}
