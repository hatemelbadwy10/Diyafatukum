part of 'user_home_cubit.dart';

class UserHomeState extends Equatable {
  const UserHomeState({
    required this.status,
    this.searchQuery = '',
  });

  final CubitStatus<UserHomeModel> status;
  final String searchQuery;

  factory UserHomeState.initial() {
    return UserHomeState(status: CubitStatus.initial());
  }

  UserHomeState copyWith({
    CubitStatus<UserHomeModel>? status,
    String? searchQuery,
  }) {
    return UserHomeState(
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [status, searchQuery];
}
