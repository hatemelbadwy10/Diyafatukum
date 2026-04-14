import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';

import '../../../data/model/address_model.dart';
import '../../../data/repository/addresses_repository.dart';

part 'addresses_state.dart';

@injectable
class AddressesCubit extends Cubit<AddressesState> {
  final AddressesRepository _repository;
  AddressesCubit(this._repository) : super(AddressesState.initial()) {
    _getAddresses();
  }

  Future<void> _getAddresses() async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getAddresses();
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(error: failure))),
      (data) => emit(state.copyWith(status: CubitStatus.success(data: data))),
    );
  }

  void updateAddress(AddressModel address) {
    final addresses = List<AddressModel>.from(state.addresses);

    final updatedAddresses = addresses.map((e) {
      if (address.isDefault) {
        return e.id == address.id ? address : e.copyWith(isDefault: false);
      } else {
        return e.id == address.id ? address : e;
      }
    }).toList();

    emit(state.copyWith(status: CubitStatus.success(data: updatedAddresses)));
  }

  void addAddress(AddressModel address) {
    final addresses = List<AddressModel>.from(state.addresses);

    // Set all existing addresses to non-default
    final updatedAddresses = addresses.map((e) => e.copyWith(isDefault: false)).toList();

    // Add new address as default
    updatedAddresses.add(address.copyWith(isDefault: true));

    emit(state.copyWith(status: CubitStatus.success(data: updatedAddresses)));
  }

  void deleteAddress(int id) {
    final addresses = List<AddressModel>.from(state.addresses);
    final updatedAddresses = addresses.where((element) => element.id != id).toList();
    emit(state.copyWith(status: CubitStatus.success(data: updatedAddresses)));
  }

  void setDefaultAddress(int id) {
    final addresses = List<AddressModel>.from(state.addresses);
    final updatedAddresses = addresses.map((address) {
      if (address.id == id) {
        return address.copyWith(isDefault: true);
      } else {
        return address.copyWith(isDefault: false);
      }
    }).toList();
    emit(state.copyWith(status: CubitStatus.success(data: updatedAddresses)));
  }

  void refresh() => _getAddresses();
}
