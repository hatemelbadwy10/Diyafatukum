part of 'reset_password_cubit.dart';

class ResetPasswordState extends Equatable {
  const ResetPasswordState({required this.status});

  final CubitStatus status;

  ResetPasswordState copyWith({CubitStatus? status, String? message}) {
    return ResetPasswordState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
