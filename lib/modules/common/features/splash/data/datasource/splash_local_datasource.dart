import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/resources/constants/pref_keys.dart';


abstract class SplashLocalDatasource {
  Future<void> saveOnboardingStatus(bool status);
  bool getOnboardingStatus();
}

@LazySingleton(as: SplashLocalDatasource)
class SplashLocalDataSourceImpl implements SplashLocalDatasource {
  final SharedPreferences sharedPreferences;

  SplashLocalDataSourceImpl(this.sharedPreferences);

  @override
  bool getOnboardingStatus() => sharedPreferences.getBool(PrefKeys.onboarding) ?? false;

  @override
  Future<void> saveOnboardingStatus(bool status) async => await sharedPreferences.setBool(PrefKeys.onboarding, status);
}
