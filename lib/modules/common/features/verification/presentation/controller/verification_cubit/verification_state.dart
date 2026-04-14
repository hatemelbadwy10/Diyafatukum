part of 'verification_cubit.dart';

class VerificationState extends Equatable {
  const VerificationState({required this.status, required this.resendStatus, this.type = VerificationType.register});
  final CubitStatus<dynamic> status;
  final CubitStatus resendStatus;
  final VerificationType type;

  VerificationState copyWith({CubitStatus<dynamic>? status, CubitStatus? resendStatus, VerificationType? type}) {
    return VerificationState(
      status: status ?? this.status,
      resendStatus: resendStatus ?? this.resendStatus,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [status, resendStatus, type];
}
