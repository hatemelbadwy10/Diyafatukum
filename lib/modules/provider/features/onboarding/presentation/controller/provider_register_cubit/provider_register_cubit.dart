import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../../core/resources/resources.dart';
import '../../../data/model/provider_specialization_model.dart';
import '../../../data/repository/provider_onboarding_repository.dart';

part 'provider_register_state.dart';

@injectable
class ProviderRegisterCubit extends Cubit<ProviderRegisterState> {
  ProviderRegisterCubit(this._repository)
    : super(ProviderRegisterState.initial());

  final ProviderOnboardingRepository _repository;

  Future<List<ProviderSpecializationModel>> loadSpecializations({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && state.specializations.isNotEmpty) {
      return state.specializations;
    }

    emit(
      state.copyWith(
        specializationsStatus: CubitStatus.loading(data: state.specializations),
      ),
    );
    final result = await _repository.getSpecializations();
    return result.fold(
      (error) {
        emit(
          state.copyWith(
            specializationsStatus: CubitStatus.failed(
              message: error.message,
              error: error,
            ),
          ),
        );
        return state.specializations;
      },
      (response) {
        final specializations = response.data ?? [];
        emit(
          state.copyWith(
            specializations: specializations,
            specializationsStatus: CubitStatus.success(data: specializations),
          ),
        );
        return specializations;
      },
    );
  }

  Future<void> register(FormData body) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final result = await _repository.register(body);
    result.fold(
      (error) => emit(
        state.copyWith(
          status: CubitStatus.failed(message: error.message, error: error),
        ),
      ),
      (response) => emit(
        state.copyWith(status: CubitStatus.success(data: response.data)),
      ),
    );
  }
}
