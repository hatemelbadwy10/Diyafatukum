part of 'delete_address_cubit.dart';

class DeleteAddressState extends Equatable {
  const DeleteAddressState({required this.status});

  final CubitStatus status;

  factory DeleteAddressState.initial() {
    return DeleteAddressState(status: CubitStatus.initial());
  }

  DeleteAddressState copyWith({CubitStatus? status}) {
    return DeleteAddressState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
