part of 'add_address_cubit.dart';

class AddAddressState extends Equatable {
  const AddAddressState({required this.status, this.latLng = const LatLng(24.774265, 46.738586)});

  final CubitStatus<AddressModel> status;
  final LatLng latLng;

  factory AddAddressState.initial() {
    return AddAddressState(status: CubitStatus.initial());
  }

  AddAddressState copyWith({CubitStatus<AddressModel>? status, LatLng? latLng}) {
    return AddAddressState(status: status ?? this.status, latLng: latLng ?? this.latLng);
  }

  @override
  List<Object> get props => [status, latLng];
}
