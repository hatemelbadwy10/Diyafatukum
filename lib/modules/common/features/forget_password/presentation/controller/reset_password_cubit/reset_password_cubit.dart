import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';

import '../../../data/repository/forget_password_repository.dart';

part 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ForgetPasswordRepository _repository;
  ResetPasswordCubit(this._repository) : super(ResetPasswordState(status: CubitStatus.initial()));

  Future<void> resetPassword({
    required String identifier,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    final usernameType = identifier.contains('@') ? 'email' : 'phone';
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.resetPassword({
      'token': token,
      'username': identifier.trim(),
      'username_type': usernameType,
      'password': password,
      'password_confirmation': confirmPassword,
    });
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (_) => emit(state.copyWith(status: CubitStatus.success())),
    );
  }
}
