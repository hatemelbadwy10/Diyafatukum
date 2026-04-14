import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/repository/addresses_repository.dart';

part 'delete_address_state.dart';

@injectable
class DeleteAddressCubit extends Cubit<DeleteAddressState> {
  final AddressesRepository _repository;
  DeleteAddressCubit(this._repository) : super(DeleteAddressState.initial());

  Future<void> deleteAddress(String id) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.deleteAddress(id);
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(error: failure))),
      (data) => emit(state.copyWith(status: CubitStatus.success(message: LocaleKeys.addresses_success_delete.tr()))),
    );
  }
}
