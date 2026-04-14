part of 'password_cubit.dart';

class PasswordState extends Equatable {
  const PasswordState({required this.status});

  final CubitStatus status;

  PasswordState copyWith({CubitStatus? status}) {
    return PasswordState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [ status];
}
