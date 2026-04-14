import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/type_defs.dart';

import '../../../../../../core/resources/constants/remote_urls.dart';

abstract class AuthRemoteDataSource {
  Future<Response> register(BodyMap body);
  Future<Response> login(BodyMap body);
  Future<Response> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;
  const AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Response> register(BodyMap body) async => client.post(RemoteUrls.register, data: body);

  @override
  Future<Response> login(BodyMap body) async => client.post(RemoteUrls.login, data: body);

  @override
  Future<Response> logout() async => client.post(RemoteUrls.logout);
}
