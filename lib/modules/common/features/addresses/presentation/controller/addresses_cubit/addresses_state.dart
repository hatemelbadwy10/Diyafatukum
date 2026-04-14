part of 'addresses_cubit.dart';

class AddressesState extends Equatable {
  const AddressesState({required this.status});

  final CubitStatus<List<AddressModel>> status;

  List<AddressModel> get addresses => status.data ?? [];

  factory AddressesState.initial() {
    return AddressesState(status: CubitStatus.initial());
  }

  AddressesState copyWith({CubitStatus<List<AddressModel>>? status}) {
    return AddressesState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
