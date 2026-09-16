import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../auth/data/model/auth_model.dart';
import '../../../data/model/bag_model.dart';
import '../../../data/repository/bag_repository.dart';
import '../../../../auth/data/repository/auth_repository.dart';

part 'bag_state.dart';

@injectable
class BagCubit extends Cubit<BagState> {
  BagCubit(this._repository, this._authRepository) : super(BagState.initial());

  final BagRepository _repository;
  final AuthRepository _authRepository;
  final Map<String, Timer> _updateTimers = {};
  final Map<String, BagModel> _previousBagStates = {};
  static const _updateDebounceDuration = Duration(milliseconds: 450);

  void _emitIfOpen(BagState newState) {
    if (isClosed) return;
    emit(newState);
  }

  Future<void> loadBag() async {
    _emitIfOpen(state.copyWith(status: CubitStatus.loading()));
    if (_isGuest) {
      _emitLocalBag();
      return;
    }

    if (_repository.getLocalBagItems().isNotEmpty) {
      final syncResult = await _repository.syncLocalBag();
      final didSync = syncResult.fold((_) => false, (_) => true);
      if (!didSync) {
        _emitLocalBag();
        return;
      }
    }

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
    if (_isGuest) {
      final items = state.bag.items.where((item) => item.id != itemId).toList();
      await _saveLocalItems(items);
      return;
    }
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
    _emitIfOpen(state.copyWith(bag: updatedBag, status: CubitStatus.success()));
    if (_isGuest) {
      _saveLocalItems(updatedItems);
      return;
    }
    _scheduleQuantitySync(itemId);
  }

  Future<void> _saveLocalItems(List<BagItemModel> items) async {
    await _repository.saveLocalBagItems(items);
    if (isClosed) return;
    _emitLocalBag(items);
  }

  void _emitLocalBag([List<BagItemModel>? sourceItems]) {
    final items = sourceItems ?? _repository.getLocalBagItems();
    final subtotal = items.fold<double>(
      0,
      (total, item) => total + item.totalPrice,
    );
    _emitIfOpen(
      state.copyWith(
        status: CubitStatus.success(),
        bag: BagModel(
          items: items,
          subtotalValue: subtotal,
          totalValue: subtotal,
        ),
      ),
    );
  }

  bool get _isGuest {
    final auth = _authRepository.getAuthData();
    return auth == null || auth == const AuthModel.guest();
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
