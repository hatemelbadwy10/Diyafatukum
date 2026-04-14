part of 'contact_us_cubit.dart';

class ContactUsState extends Equatable {
  const ContactUsState({required this.status});

  final CubitStatus status;

  ContactUsState copyWith({CubitStatus? status}) {
    return ContactUsState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
