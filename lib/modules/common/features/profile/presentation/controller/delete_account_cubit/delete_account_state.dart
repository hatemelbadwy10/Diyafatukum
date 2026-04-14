part of 'delete_account_cubit.dart';

class DeleteAccountState extends Equatable {
  const DeleteAccountState({required this.status});

  final CubitStatus status;

  DeleteAccountState copyWith({CubitStatus? status, String? message}) {
    return DeleteAccountState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
