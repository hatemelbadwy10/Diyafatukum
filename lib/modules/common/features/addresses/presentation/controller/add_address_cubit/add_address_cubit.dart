import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../../../data/model/address_model.dart';
import '../../../data/repository/addresses_repository.dart';

part 'add_address_state.dart';

@injectable
class AddAddressCubit extends Cubit<AddAddressState> {
  final AddressesRepository _repository;
  AddAddressCubit(this._repository) : super(AddAddressState.initial());

  Future<void> addAddress({bool isEdit = false, required BodyMap body}) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = isEdit ? await _repository.updateAddress(body) : await _repository.addAddress(body);
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(error: failure))),
      (data) => emit(
        state.copyWith(
          status: CubitStatus.success(
            data: data,
            message: isEdit ? LocaleKeys.addresses_success_edit.tr() : LocaleKeys.addresses_success_add.tr(),
          ),
        ),
      ),
    );
  }

  Future<void> setAsDefault(int addressId) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.updateAddress({'id': addressId.toString(), 'is_primary': 1});
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(error: failure))),
      (data) => emit(state.copyWith(status: CubitStatus.success(data: data))),
    );
  }
}
