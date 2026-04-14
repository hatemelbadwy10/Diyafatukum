import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

import '../../../../../../../core/resources/type_defs.dart';

abstract class ProfileRemoteDataSource {
  Future<Response> getProfile();

  Future<Response> updateProfile(BodyMap body);

  Future<Response> changePhone(BodyMap body);

  Future<Response> changePassword(BodyMap body);

  Future<Response> deleteAccount(String password);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient client;
  const ProfileRemoteDataSourceImpl(this.client);

  @override
  Future<Response> getProfile() async => client.get(RemoteUrls.profile);

  @override
  Future<Response> updateProfile(BodyMap body) async => client.post(RemoteUrls.profile, data: body);

  @override
  Future<Response> changePhone(BodyMap body) async => client.post(RemoteUrls.changePhone, data: body);

  @override
  Future<Response> changePassword(BodyMap body) async => client.post(RemoteUrls.changePassword, data: body);

  @override
  Future<Response> deleteAccount(String password) async {
    return client.post(RemoteUrls.deleteAccount, data: {'password': password});
  }
}
