import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../../core/resources/type_defs.dart';

import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../data/repository/settings_repository.dart';

part 'contact_us_state.dart';

@injectable
class ContactUsCubit extends Cubit<ContactUsState> {
  final SettingsRepository _repository;
  ContactUsCubit(this._repository) : super(ContactUsState(status: CubitStatus.initial()));

  Future<void> contactUs(BodyMap body) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final response = await _repository.contactUs(body);
    response.fold(
      (error) => emit(state.copyWith(status: CubitStatus.failed(message: error.message))),
      (_) => emit(state.copyWith(status: CubitStatus.success(data: LocaleKeys.settings_contact_success.tr()))),
    );
  }
}
