part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({required this.status});

  final CubitStatus<UserModel> status;

  factory ProfileState.initial() {
    return ProfileState(status: CubitStatus.initial());
  }

  ProfileState copyWith({CubitStatus<UserModel>? status}) {
    return ProfileState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
