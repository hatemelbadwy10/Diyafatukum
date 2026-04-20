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

  void loadBag() {
    emit(state.copyWith(status: CubitStatus.loading()));
    final bag = _repository.getBag();
    emit(
      state.copyWith(
        status: CubitStatus.success(),
        bag: bag,
      ),
    );
  }

  Future<void> removeItem(String itemId) async {
    await _repository.removeItem(itemId);
    loadBag();
  }
}
