import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../../../../core/resources/resources.dart';

import '../../../data/repository/profile_repository.dart';

part 'phone_state.dart';

@injectable
class PhoneCubit extends Cubit<PhoneState> {
  final ProfileRepository _repository;
  PhoneCubit(this._repository) : super(PhoneState(status: CubitStatus.initial()));

  Future<void> changePhone(String phone) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.changePhone({'username': phone, 'username_type': 'phone'});
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (_) => emit(state.copyWith(status: CubitStatus.success())),
    );
  }
}
