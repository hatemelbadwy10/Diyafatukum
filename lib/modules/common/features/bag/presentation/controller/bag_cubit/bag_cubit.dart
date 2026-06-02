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
  final Map<String, BagModel> _previousBagStates = {};
  static const _updateDebounceDuration = Duration(milliseconds: 450);

  void _emitIfOpen(BagState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> loadBag() async {
    _emitIfOpen(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getBag();
    if (isClosed) return;
    response.fold(
      (failure) => _emitIfOpen(
        state.copyWith(
          status: CubitStatus.failed(message: failure.message, error: failure),
        ),
      ),
      (data) => _emitIfOpen(
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
    if (isClosed) return;
    response.fold(
      (failure) => _emitIfOpen(
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

    _previousBagStates[itemId] = state.bag;

    final updatedItems = state.bag.items.map((item) {
      if (item.id != itemId) return item;
      return item.copyWith(quantity: item.quantity + change);
    }).toList();
    final updatedSubtotal = updatedItems.fold<double>(
      0,
      (total, item) => total + item.totalPrice,
    );
    final updatedBag = state.bag.copyWith(
      items: updatedItems,
      subtotalValue: updatedSubtotal,
      totalValue: updatedSubtotal - state.bag.discount,
    );
    _emitIfOpen(
      state.copyWith(
        bag: updatedBag,
        status: CubitStatus.success(),
      ),
    );
    _scheduleQuantitySync(itemId);
  }

  void _scheduleQuantitySync(String itemId) {
    _cancelPendingUpdate(itemId);
    _updateTimers[itemId] = Timer(_updateDebounceDuration, () async {
      _updateTimers.remove(itemId);
      if (isClosed) return;
      final item = _findItemById(itemId);
      if (item == null) return;

      final response = await _repository.updateItemQuantity(
        item.id,
        item.quantity,
      );
      if (isClosed) return;
      response.fold(
        (failure) {
          final previousBag = _previousBagStates.remove(itemId);

          if (previousBag != null) {
            _emitIfOpen(
              state.copyWith(
                bag: previousBag,
                status: CubitStatus.failed(
                  message: failure.message,
                  error: failure,
                ),
              ),
            );
          } else {
            _emitIfOpen(
              state.copyWith(
                status: CubitStatus.failed(
                  message: failure.message,
                  error: failure,
                ),
              ),
            );
          }
        },
        (data) {
          _previousBagStates.remove(itemId);
          _emitIfOpen(
            state.copyWith(
              bag: data.data ?? state.bag,
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
    _previousBagStates.clear();
    return super.close();
  }
}
