import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/resources/type_defs.dart';

import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';

import '../../../data/repository/auth_repository.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;
  RegisterCubit(this._repository) : super(RegisterState(status: CubitStatus.initial()));

  void register(BodyMap body) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final result = await _repository.register(body);
    result.fold((error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))), (response) {
      emit(state.copyWith(status: CubitStatus.success(data: response.data)));
    });
  }
}
