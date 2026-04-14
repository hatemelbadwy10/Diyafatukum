part of 'address_cubit.dart';

class AddressState extends Equatable {
  const AddressState({required this.status});

  final CubitStatus<AddressModel> status;

  factory AddressState.initial() {
    return AddressState(status: CubitStatus.initial());
  }

  AddressState copyWith({CubitStatus<AddressModel>? status}) {
    return AddressState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
