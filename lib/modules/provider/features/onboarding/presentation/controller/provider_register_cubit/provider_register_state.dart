part of 'provider_register_cubit.dart';

class ProviderRegisterState extends Equatable {
  const ProviderRegisterState({required this.status});

  final CubitStatus<dynamic> status;

  ProviderRegisterState copyWith({CubitStatus<dynamic>? status}) {
    return ProviderRegisterState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
