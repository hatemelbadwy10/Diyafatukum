import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';

import '../../../../../../../core/resources/type_defs.dart';

abstract class ForgetPasswordRemoteDataSource {
  Future<Response> forgetPassword(String identifier);
  Future<Response> resetPassword(BodyMap body);
}

@LazySingleton(as: ForgetPasswordRemoteDataSource)
class ForgetPasswordRemoteDataSourceImpl implements ForgetPasswordRemoteDataSource {
  final ApiClient client;
  const ForgetPasswordRemoteDataSourceImpl(this.client);

  @override
  Future<Response> forgetPassword(String identifier) {
    final username = identifier.trim();
    final usernameType = username.contains('@') ? 'email' : 'phone';
    return client.post(
      RemoteUrls.forgetPassword,
      data: {
        'username': username,
        'username_type': usernameType,
      },
    );
  }

  @override
  Future<Response> resetPassword(BodyMap body) => client.post(RemoteUrls.resetPassword, data: body);
}
