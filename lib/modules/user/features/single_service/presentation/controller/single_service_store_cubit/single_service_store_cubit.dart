import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../core/resources/resources.dart';
import '../../../../home/data/model/user_home_model.dart';
import '../../../data/model/single_service_model.dart';
import '../../../data/model/single_service_store_model.dart';
import '../../../data/repository/single_service_repository.dart';

part 'single_service_store_state.dart';

@injectable
class SingleServiceStoreCubit extends Cubit<SingleServiceStoreState> {
  SingleServiceStoreCubit(this._repository)
    : super(SingleServiceStoreState.initial());

  final SingleServiceRepository _repository;

  late UserHomeServiceModel _service;
  late SingleServiceProductModel _store;

  void initialize(
    UserHomeServiceModel service,
    SingleServiceProductModel store,
  ) {
    _service = service;
    _store = store;
    emit(
      state.copyWith(
        status: CubitStatus.success(data: store.name),
        service: service,
        store: store,
      ),
    );
    _loadStore();
  }

  Future<void> _loadStore() async {
    emit(state.copyWith(status: CubitStatus.loading(data: state.status.data)));

    final result = await _repository.getStore(_service.serviceKey, _store.id, {
      'page': '1',
    });

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CubitStatus.failed(
              message: failure.message,
              error: failure,
            ),
          ),
        );
      },
      (response) {
        final storeData = response.data;
        if (storeData == null) {
          emit(
            state.copyWith(
              status: CubitStatus.failed(message: response.message ?? ''),
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: CubitStatus.success(data: _store.name),
            storeDetails: storeData,
            categories: _buildCategories(storeData),
            selectedCategoryId: _allCategoryId,
            items: storeData.items,
            filteredItems: storeData.items,
          ),
        );
      },
    );
  }

  void selectCategory(String categoryId) {
    final filteredItems = categoryId == _allCategoryId
        ? state.items
        : state.items.where((item) => item.categoryId == categoryId).toList();
    emit(
      state.copyWith(
        selectedCategoryId: categoryId,
        filteredItems: filteredItems,
      ),
    );
  }

  void selectItem(SingleServiceStoreItemModel item) {
    if (!item.isAvailable) return;

    final quantities = Map<String, int>.from(state.quantities);
    quantities[item.id] = 1;
    _emitSelectionState(quantities);
  }

  void incrementItem(SingleServiceStoreItemModel item) {
    if (!item.isAvailable) return;

    final quantities = Map<String, int>.from(state.quantities);
    final nextQuantity = (quantities[item.id] ?? 0) + 1;
    if (nextQuantity > item.quantity) return;

    quantities[item.id] = nextQuantity;
    _emitSelectionState(quantities);
  }

  void decrementItem(SingleServiceStoreItemModel item) {
    final quantities = Map<String, int>.from(state.quantities);
    final currentQuantity = quantities[item.id] ?? 0;
    if (currentQuantity <= 1) {
      quantities.remove(item.id);
    } else {
      quantities[item.id] = currentQuantity - 1;
    }
    _emitSelectionState(quantities);
  }

  void clearSelection() {
    _emitSelectionState(const {});
  }

  void _emitSelectionState(Map<String, int> quantities) {
    emit(
      state.copyWith(
        quantities: quantities,
        totalPrice: _calculateTotalPrice(quantities),
      ),
    );
  }

  double _calculateTotalPrice(Map<String, int> quantities) {
    return state.items.fold(0, (total, item) {
      return total + item.price * (quantities[item.id] ?? 0);
    });
  }

  List<SingleServiceStoreCategoryModel> _buildCategories(
    SingleServiceStoreDetailsModel storeData,
  ) {
    final categories = storeData.categories;
    final hasAll = categories.any((category) => category.id == _allCategoryId);
    if (hasAll) return categories;

    return [
      SingleServiceStoreCategoryModel(
        id: _allCategoryId,
        name: LocaleKeys.home_user_store_categories_all.tr(),
        description: '',
        productsCount: storeData.items.length,
      ),
      ...categories,
    ];
  }

  static const String _allCategoryId = '0';
}
