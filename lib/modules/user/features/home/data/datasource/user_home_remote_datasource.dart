import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../../core/resources/type_defs.dart';

abstract class UserHomeRemoteDataSource {
  Future<Response> getHomeData(ParamsMap params);
}

@LazySingleton(as: UserHomeRemoteDataSource)
class UserHomeRemoteDataSourceImpl implements UserHomeRemoteDataSource {
  const UserHomeRemoteDataSourceImpl(this.client);

  final ApiClient client;

  @override
  Future<Response> getHomeData(ParamsMap params) async =>
      client.get(RemoteUrls.userHome, queryParameters: params);
}
