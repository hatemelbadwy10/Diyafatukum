import 'package:injectable/injectable.dart';

import '../datasource/splash_local_datasource.dart';
import '../datasource/splash_remote_datasource.dart';

abstract class SplashRepository {
  Future<void> saveOnboardingStatus(bool status);
  bool getOnboardingStatus();
}

@LazySingleton(as: SplashRepository)
class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource remoteDataSource;
  final SplashLocalDatasource localDataSource;
  const SplashRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  bool getOnboardingStatus() => localDataSource.getOnboardingStatus();

  @override
  Future<void> saveOnboardingStatus(bool status) async => await localDataSource.saveOnboardingStatus(status);
}
