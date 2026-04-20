part of 'single_service_cubit.dart';

class SingleServiceState extends Equatable {
  const SingleServiceState({
    required this.status,
    this.service,
  });

  final CubitStatus<String> status;
  final UserHomeServiceModel? service;

  factory SingleServiceState.initial() {
    return SingleServiceState(status: CubitStatus.initial());
  }

  SingleServiceState copyWith({
    CubitStatus<String>? status,
    UserHomeServiceModel? service,
  }) {
    return SingleServiceState(
      status: status ?? this.status,
      service: service ?? this.service,
    );
  }

  @override
  List<Object?> get props => [status, service];
}
