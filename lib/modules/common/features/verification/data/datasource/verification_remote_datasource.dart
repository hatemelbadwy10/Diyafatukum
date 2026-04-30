import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/resources/constants/remote_urls.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../model/verification_type_enum.dart';

abstract class VerificationRemoteDataSource {
  Future<Response> verify({
    required BodyMap body,
    required VerificationType type,
  });
  Future<Response> resendCode({
    required BodyMap body,
    required VerificationType type,
  });
}

@LazySingleton(as: VerificationRemoteDataSource)
class VerificationRemoteDataSourceImpl implements VerificationRemoteDataSource {
  final ApiClient client;
  const VerificationRemoteDataSourceImpl(this.client);

  @override
  Future<Response> verify({
    required BodyMap body,
    required VerificationType type,
  }) async {
    return type.verify(
      onRegister: () => _verifyAccount(body),
      onChangePhone: () => _verifyPhone(body),
      onChangeEmail: () => _verifyPhone(body),
      onForgetPassword: () => _verifyForgetPassword(body),
    );
  }

  @override
  Future<Response> resendCode({
    required BodyMap body,
    required VerificationType type,
  }) async {
    return type.verify(
      onRegister: () => _resendAccountCode(body),
      onChangePhone: () => _resendPhoneCode(body),
      onChangeEmail: () => _resendPhoneCode(body),
      onForgetPassword: () => _resendForgetPasswordCode(body),
    );
  }

  Future<Response> _verifyAccount(BodyMap body) async =>
      client.post(RemoteUrls.verifyAccount, data: body);

  Future<Response> _verifyPhone(BodyMap body) async =>
      client.post(RemoteUrls.verifyPhone, data: body);

  Future<Response> _verifyForgetPassword(BodyMap body) async =>
      client.post(RemoteUrls.verifyPassword, data: body);

  Future<Response> _resendAccountCode(BodyMap body) async =>
      client.post(RemoteUrls.resendCode, data: body);

  Future<Response> _resendPhoneCode(BodyMap body) async =>
      client.post(RemoteUrls.resendPhoneCode, data: body);

  Future<Response> _resendForgetPasswordCode(BodyMap body) async {
    return client.post(RemoteUrls.resendPasswordCode, data: body);
  }
}
