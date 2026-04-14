import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../../../../auth/data/model/auth_model.dart';
import '../../../../profile/data/model/user_model.dart';
import '../../../data/model/verification_type_enum.dart';
import '../../../data/repository/verification_repository.dart';

part 'verification_state.dart';

@injectable
class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepository _repository;
  VerificationCubit(this._repository)
      : super(VerificationState(status: CubitStatus.initial(), resendStatus: CubitStatus.initial()));

  void setType(VerificationType type) => emit(state.copyWith(type: type));

  Future<void> verify({AuthModel? auth, required BodyMap body}) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final result = await _repository.verify(body: body, type: state.type);
    result.fold((failure) => emit(state.copyWith(status: CubitStatus.failed(message: failure.message))), (response) {
      AuthModel authModel = auth ?? const AuthModel.guest();
      if (response.data is AuthModel) {
        authModel = response.data;
        emit(state.copyWith(status: CubitStatus.success(data: authModel)));
      } else if (response.data is UserModel) {
        authModel = authModel.copyWith(user: response.data);
        emit(state.copyWith(status: CubitStatus.success(data: authModel)));
      } else if (response.data is String) {
        emit(state.copyWith(status: CubitStatus.success(data: response)));
      } else {
        emit(state.copyWith(status: CubitStatus.failed(message: 'Unknown response type')));
        return;
      }
    });
  }

  Future<void> resendCode({required String phone}) async {
    emit(state.copyWith(resendStatus: CubitStatus.loading(), status: CubitStatus.initial()));
    final response = await _repository.resendCode(phone: phone, type: state.type);

    response.fold(
      (failure) => emit(state.copyWith(resendStatus: CubitStatus.failed(message: failure.message))),
      (_) => emit(state.copyWith(resendStatus: CubitStatus.success())),
    );
  }
}
