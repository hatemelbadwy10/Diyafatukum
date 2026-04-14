import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/resources/type_defs.dart';

import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/repository/profile_repository.dart';

part 'password_state.dart';

@injectable
class PasswordCubit extends Cubit<PasswordState> {
  final ProfileRepository _repository;
  PasswordCubit(this._repository) : super(PasswordState(status: CubitStatus.initial()));

  Future<void> changePassword(BodyMap body) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.changePassword(body);
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (_) => emit(state.copyWith(status: CubitStatus.success(message: LocaleKeys.auth_password_change_success.tr()))),
    );
  }
}
