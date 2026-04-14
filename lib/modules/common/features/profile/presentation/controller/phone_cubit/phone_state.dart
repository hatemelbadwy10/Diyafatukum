part of 'phone_cubit.dart';

class PhoneState extends Equatable {
  const PhoneState({required this.status});

  final CubitStatus status;


  PhoneState copyWith({CubitStatus? status}) {
    return PhoneState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
