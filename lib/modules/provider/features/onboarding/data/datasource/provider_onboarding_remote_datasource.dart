import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

abstract class ProviderOnboardingRemoteDataSource {
  Future<Response> register(FormData body);
  Future<Response> getSpecializations();
}

@LazySingleton(as: ProviderOnboardingRemoteDataSource)
class ProviderOnboardingRemoteDataSourceImpl
    implements ProviderOnboardingRemoteDataSource {
  const ProviderOnboardingRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> register(FormData body) {
    return client.post(
      RemoteUrls.providerRegister,
      data: body,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<Response> getSpecializations() {
    return client.get(RemoteUrls.specializations);
  }
}
