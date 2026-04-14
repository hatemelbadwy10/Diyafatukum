import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/utils/notifications.dart';
import '../../../../../../../core/resources/resources.dart';

import '../../../data/repository/settings_repository.dart';

part 'language_state.dart';

@injectable
class LanguageCubit extends Cubit<LanguageState> {
  final SettingsRepository _settingsRepository;
  LanguageCubit(this._settingsRepository) : super(LanguageState.initial());

  Future<void> changeLanguage(String languageCode) async {
    emit(state.copyWith(status: CubitStatus.loading()));
    final deviceToken = await RemoteNotificationServices.getFcmToken();
    final response = await _settingsRepository.changeLanguage({
      'device_token': deviceToken,
      'preferred_language': languageCode,
    });
    response.fold(
      (failure) => emit(state.copyWith(status: CubitStatus.failed(message: failure.message))),
      (_) => emit(state.copyWith(status: CubitStatus.success())),
    );
  }
}
