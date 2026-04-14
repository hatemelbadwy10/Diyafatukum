import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';

import '../../../data/model/address_model.dart';
import '../../../data/repository/addresses_repository.dart';

part 'default_address_state.dart';

@injectable
class DefaultAddressCubit extends Cubit<DefaultAddressState> {
  final AddressesRepository _repository;
  DefaultAddressCubit(this._repository) : super(DefaultAddressState.initial());

  Future<void> setDefaultAddress(AddressModel address) async {
    emit(state.copyWith(status: CubitStatus.loading(), address: address));
    final response = await _repository.setDefaultAddress(address.id.toString());
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(error: failure))),
      (data) => emit(state.copyWith(status: CubitStatus.success(data: data))),
    );
  }
}
