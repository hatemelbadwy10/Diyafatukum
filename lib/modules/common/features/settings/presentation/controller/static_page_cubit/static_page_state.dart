part of 'static_page_cubit.dart';

class StaticPageState extends Equatable {
  const StaticPageState({required this.status});

  final CubitStatus<String> status;

  StaticPageState copyWith({CubitStatus<String>? status}) {
    return StaticPageState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
