part of 'default_address_cubit.dart';

class DefaultAddressState extends Equatable {
  const DefaultAddressState({required this.status, this.address = const AddressModel.empty()});

  final CubitStatus status;
  final AddressModel address;

  factory DefaultAddressState.initial() => DefaultAddressState(status: CubitStatus.initial());

  DefaultAddressState copyWith({CubitStatus? status, AddressModel? address}) {
    return DefaultAddressState(status: status ?? this.status, address: address ?? this.address);
  }

  @override
  List<Object> get props => [status, address];
}
