part of 'provider_register_cubit.dart';

class ProviderRegisterState extends Equatable {
  const ProviderRegisterState({
    required this.status,
    required this.specializationsStatus,
    required this.specializations,
  });

  final CubitStatus<dynamic> status;
  final CubitStatus<List<ProviderSpecializationModel>> specializationsStatus;
  final List<ProviderSpecializationModel> specializations;

  factory ProviderRegisterState.initial() {
    return ProviderRegisterState(
      status: CubitStatus.initial(),
      specializationsStatus: CubitStatus.initial(),
      specializations: const [],
    );
  }

  ProviderRegisterState copyWith({
    CubitStatus<dynamic>? status,
    CubitStatus<List<ProviderSpecializationModel>>? specializationsStatus,
    List<ProviderSpecializationModel>? specializations,
  }) {
    return ProviderRegisterState(
      status: status ?? this.status,
      specializationsStatus:
          specializationsStatus ?? this.specializationsStatus,
      specializations: specializations ?? this.specializations,
    );
  }

  @override
  List<Object?> get props => [status, specializationsStatus, specializations];
}
