import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';

abstract class SplashRemoteDataSource {}

@LazySingleton(as: SplashRemoteDataSource)
class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final ApiClient client;
  const SplashRemoteDataSourceImpl(this.client);
}
