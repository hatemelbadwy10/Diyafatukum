part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({required this.status});

  final CubitStatus<dynamic> status;

  RegisterState copyWith({CubitStatus<dynamic>? status}) {
    return RegisterState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
