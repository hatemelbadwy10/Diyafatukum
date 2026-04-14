part of 'forget_password_cubit.dart';

class ForgetPasswordState extends Equatable {
  const ForgetPasswordState({required this.status});

  final CubitStatus<String> status;

  ForgetPasswordState copyWith({CubitStatus<String>? status}) {
    return ForgetPasswordState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
