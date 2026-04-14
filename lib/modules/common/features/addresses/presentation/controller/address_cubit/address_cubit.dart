import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/model/address_model.dart';
import '../../../data/repository/addresses_repository.dart';

part 'address_state.dart';

@injectable
class AddressCubit extends Cubit<AddressState> {
  final AddressesRepository _repository;
  AddressCubit(this._repository) : super(AddressState.initial());

  Future<void> getAddressDetails(String? id) async {
    if (id == null) return;
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getAddressDetails(id);
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(error: failure))),
      (data) => emit(state.copyWith(status: CubitStatus.success(data: data))),
    );
  }
}
