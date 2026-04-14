import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../data/repository/splash_repository.dart';

part 'splash_state.dart';

@lazySingleton
class SplashCubit extends Cubit<SplashState> {
  final SplashRepository _repository;
  SplashCubit(this._repository) : super(const SplashState()) {
    _getOnboardingStatus();
  }

  void saveOnboardingStatus(bool status) {
    _repository.saveOnboardingStatus(status);
    emit(state.copyWith(isOnboardingViewed: status));
  }

  void _getOnboardingStatus() {
    final status = _repository.getOnboardingStatus();
    emit(state.copyWith(isOnboardingViewed: status));
  }
}
