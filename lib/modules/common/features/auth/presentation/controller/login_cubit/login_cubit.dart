import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../../../data/model/login_response_model.dart';
import '../../../data/repository/auth_repository.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _repository;
  LoginCubit(this._repository) : super(LoginState(status: CubitStatus.initial()));

  void login(BodyMap body) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.login(body);
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (data) => emit(state.copyWith(status: CubitStatus.success(data: data.data))),
    );
  }
}
