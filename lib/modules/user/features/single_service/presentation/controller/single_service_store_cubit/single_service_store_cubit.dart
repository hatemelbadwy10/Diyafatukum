import 'package:bloc/bloc.dart';
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

    final result = await _repository.getStore(
      _service.iconKey,
      _store.id,
      {'page': '1'},
    );

    result.fold((failure) {
      emit(
        state.copyWith(
          status: CubitStatus.failed(
            message: failure.message,
            error: failure,
          ),
        ),
      );
    }, (response) {
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
          items: storeData.items,
        ),
      );
    });
  }

  void selectItem(SingleServiceStoreItemModel item) {
    final quantities = Map<String, int>.from(state.quantities);
    quantities[item.id] = 1;
    _emitSelectionState(quantities);
  }

  void incrementItem(SingleServiceStoreItemModel item) {
    final quantities = Map<String, int>.from(state.quantities);
    quantities[item.id] = (quantities[item.id] ?? 0) + 1;
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
}
