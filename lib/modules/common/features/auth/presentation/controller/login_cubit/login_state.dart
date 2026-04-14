part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({required this.status});

  final CubitStatus<AuthModel> status;

  LoginState copyWith({CubitStatus<AuthModel>? status}) {
    return LoginState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
