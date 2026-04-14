part of 'language_cubit.dart';

class LanguageState extends Equatable {
  const LanguageState({required this.status});

  final CubitStatus status;

  factory LanguageState.initial() {
    return LanguageState(status: CubitStatus.initial());
  }

  LanguageState copyWith({CubitStatus? status}) {
    return LanguageState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
