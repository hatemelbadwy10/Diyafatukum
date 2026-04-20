import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/provider_home_model.dart';
import '../../../data/repository/provider_home_repository.dart';

part 'provider_home_state.dart';

@injectable
class ProviderHomeCubit extends Cubit<ProviderHomeState> {
  ProviderHomeCubit(this._repository) : super(ProviderHomeState.initial());

  final ProviderHomeRepository _repository;

  Future<void> loadHome() async {
    emit(state.copyWith(status: CubitStatus.loading()));

    final result = await _repository.getHomeData();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CubitStatus.failed(
            message: failure.message,
            error: failure,
          ),
        ),
      ),
      (response) {
        final home = response.data;
        emit(
          state.copyWith(
            status: CubitStatus.success(data: home),
            home: home,
            orders: home?.orders ?? const [],
          ),
        );
      },
    );
  }

  void acceptOrder(String id) {
    _updateOrderStatus(id, ProviderHomeOrderStatus.accepted);
  }

  void rejectOrder(String id) {
    _updateOrderStatus(id, ProviderHomeOrderStatus.rejected);
  }

  void _updateOrderStatus(String id, ProviderHomeOrderStatus status) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == id) {
        return order.copyWith(status: status);
      }
      return order;
    }).toList();

    emit(state.copyWith(orders: updatedOrders));
  }
}
