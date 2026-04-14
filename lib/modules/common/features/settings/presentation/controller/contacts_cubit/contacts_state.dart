part of 'contacts_cubit.dart';

class ContactsState extends Equatable {
  const ContactsState({required this.status});

  final CubitStatus<Map<SocialMediaPlatform, String>> status;

  factory ContactsState.initial() {
    return ContactsState(status: CubitStatus.initial());
  }

  ContactsState copyWith({CubitStatus<Map<SocialMediaPlatform, String>>? status}) {
    return ContactsState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
