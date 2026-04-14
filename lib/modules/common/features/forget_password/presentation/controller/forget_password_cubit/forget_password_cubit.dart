import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/repository/forget_password_repository.dart';

part 'forget_password_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepository _repository;
  ForgetPasswordCubit(this._repository) : super(ForgetPasswordState(status: CubitStatus.initial()));

  Future<void> forgetPassword(String value) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.forgetPassword(value);
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (code) => emit(state.copyWith(status: CubitStatus.success(data: code.toString()))),
    );
  }
}
