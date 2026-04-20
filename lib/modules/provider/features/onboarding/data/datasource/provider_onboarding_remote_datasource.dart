import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../core/resources/type_defs.dart';

abstract class ProviderOnboardingRemoteDataSource {
  Future<Response> register(BodyMap body);
}

@LazySingleton(as: ProviderOnboardingRemoteDataSource)
class ProviderOnboardingRemoteDataSourceImpl
    implements ProviderOnboardingRemoteDataSource {
  const ProviderOnboardingRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> register(BodyMap body) {
    return client.post(RemoteUrls.providerRegister, data: body);
  }
}
