part of 'user_home_cubit.dart';

class UserHomeState extends Equatable {
  const UserHomeState({required this.status});

  final CubitStatus<UserHomeModel> status;

  factory UserHomeState.initial() {
    return UserHomeState(status: CubitStatus.initial());
  }

  UserHomeState copyWith({CubitStatus<UserHomeModel>? status}) {
    return UserHomeState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
