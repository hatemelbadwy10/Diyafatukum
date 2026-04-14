import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';

import '../../../data/model/social_media_platform_enum.dart';
import '../../../data/repository/settings_repository.dart';

part 'contacts_state.dart';

@injectable
class ContactsCubit extends Cubit<ContactsState> {
  final SettingsRepository _repository;
  ContactsCubit(this._repository) : super(ContactsState.initial()) {
    _getContacts();
  }

  Future<void> _getContacts() async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.getContacts();
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (platforms) => emit(state.copyWith(status: CubitStatus.success(data: platforms))),
    );
  }
}
