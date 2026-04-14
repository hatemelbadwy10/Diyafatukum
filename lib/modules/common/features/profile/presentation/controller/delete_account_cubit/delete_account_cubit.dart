import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/repository/profile_repository.dart';


part 'delete_account_state.dart';

@injectable
class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final ProfileRepository _repository;
  DeleteAccountCubit(this._repository) : super(DeleteAccountState(status: CubitStatus.initial()));

  Future<void> deleteAccount(String password) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.deleteAccount(password);
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(message: failure.message))),
      (_) => emit(state.copyWith(status: CubitStatus.success(message: LocaleKeys.account_profile_delete_success.tr()))),
    );
  }
}
