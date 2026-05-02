import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/bag_model.dart';
import '../../../data/repository/bag_repository.dart';

part 'bag_state.dart';

@injectable
class BagCubit extends Cubit<BagState> {
  BagCubit(this._repository) : super(BagState.initial());

  final BagRepository _repository;
  final Map<String, Timer> _updateTimers = {};
  final Map<String, BagItemModel> _previousItemStates = {};
  static const _updateDebounceDuration = Duration(milliseconds: 450);

  Future<void> loadBag() async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getBag();
    response.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message, error: failure),
        ),
      ),
      (data) => emit(
        state.copyWith(
          status: CubitStatus.success(),
          bag: data.data ?? const BagModel(items: []),
        ),
      ),
    );
  }

  Future<void> removeItem(String itemId) async {
    _cancelPendingUpdate(itemId);
    final response = await _repository.removeItem(itemId);
    response.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message, error: failure),
        ),
      ),
      (_) => loadBag(),
    );
  }

  void incrementItemQuantity(String itemId) {
    _updateItemQuantity(itemId, change: 1);
  }

  void decrementItemQuantity(String itemId) {
    final item = _findItemById(itemId);
    if (item == null) return;
    if (item.quantity <= 1) {
      removeItem(itemId);
      return;
    }
    _updateItemQuantity(itemId, change: -1);
  }

  void _updateItemQuantity(String itemId, {required int change}) {
    final item = _findItemById(itemId);
    if (item == null) return;
    
    // Store previous state for rollback
    _previousItemStates[itemId] = item;
    
    final updatedItems = state.bag.items.map((item) {
      if (item.id != itemId) return item;
      return item.copyWith(quantity: item.quantity + change);
    }).toList();
    emit(
      state.copyWith(
        bag: state.bag.copyWith(items: updatedItems),
        status: CubitStatus.success(),
      ),
    );
    _scheduleQuantitySync(itemId);
  }

  void _scheduleQuantitySync(String itemId) {
    _cancelPendingUpdate(itemId);
    _updateTimers[itemId] = Timer(_updateDebounceDuration, () async {
      _updateTimers.remove(itemId);
      final item = _findItemById(itemId);
      if (item == null) return;

      final response = await _repository.updateItemQuantity(
        item.id,
        item.quantity,
      );
      response.fold(
        (failure) {
          // On failure, revert to previous state and show error
          final previousItem = _previousItemStates[itemId];
          _previousItemStates.remove(itemId);
          
          if (previousItem != null) {
            final revertedItems = state.bag.items.map((currentItem) {
              if (currentItem.id != itemId) return currentItem;
              return previousItem;
            }).toList();
            
            emit(
              state.copyWith(
                bag: state.bag.copyWith(items: revertedItems),
                status: CubitStatus.failed(message: failure.message, error: failure),
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: CubitStatus.failed(message: failure.message, error: failure),
              ),
            );
          }
        },
        (_) {
          // On success, keep the optimistic update and emit success
          _previousItemStates.remove(itemId);
          emit(
            state.copyWith(
              status: CubitStatus.success(),
            ),
          );
        },
      );
    });
  }

  void _cancelPendingUpdate(String itemId) {
    _updateTimers.remove(itemId)?.cancel();
  }

  BagItemModel? _findItemById(String itemId) {
    final index = state.bag.items.indexWhere((item) => item.id == itemId);
    if (index == -1) return null;
    return state.bag.items[index];
  }

  @override
  Future<void> close() {
    for (final timer in _updateTimers.values) {
      timer.cancel();
    }
    _updateTimers.clear();
    return super.close();
  }
}
