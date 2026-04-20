import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../core/resources/resources.dart';
import '../../../../../../../../core/resources/type_defs.dart';
import '../../../data/repository/provider_onboarding_repository.dart';

part 'provider_register_state.dart';

@injectable
class ProviderRegisterCubit extends Cubit<ProviderRegisterState> {
  ProviderRegisterCubit(this._repository)
      : super(ProviderRegisterState(status: CubitStatus.initial()));

  final ProviderOnboardingRepository _repository;

  Future<void> register(BodyMap body) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final result = await _repository.register(body);
    result.fold(
      (error) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: error.message, error: error),
        ),
      ),
      (_) => emit(state.copyWith(status: CubitStatus.success())),
    );
  }
}
