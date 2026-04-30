import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/type_defs.dart';
import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../auth/data/model/auth_model.dart';
import '../datasource/verification_remote_datasource.dart';
import '../model/verification_type_enum.dart';

abstract class VerificationRepository {
  Result<dynamic> verify({
    required BodyMap body,
    required VerificationType type,
  });
  Result resendCode({
    required String identifier,
    required VerificationType type,
  });
}

@LazySingleton(as: VerificationRepository)
class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationRemoteDataSource remoteDataSource;
  const VerificationRepositoryImpl(this.remoteDataSource);

  @override
  Result<dynamic> verify({
    required BodyMap body,
    required VerificationType type,
  }) async {
    switch (type) {
      case VerificationType.register:
        return _verifyAccount(body);
      case VerificationType.changePhone:
        return _verifyPhone(body);
      case VerificationType.changeEmail:
        return _verifyPhone(body);
      case VerificationType.forgetPassword:
        return _verifyForgetPassword(body);
    }
  }

  @override
  Result resendCode({
    required String identifier,
    required VerificationType type,
  }) async {
    final codeBody = type == VerificationType.register
        ? {'identifier': identifier, 'register': true}
        : type == VerificationType.changePhone
        ? {'phone': identifier}
        : {
            'username': identifier,
            'username_type': identifier.contains('@') ? 'email' : 'phone',
            'test_mode': '1',
          };
    return remoteDataSource
        .resendCode(body: codeBody, type: type)
        .toResult(noDataFromJson);
  }

  // Private methods to handle specific verification types
  Result<AuthModel> _verifyAccount(BodyMap body) async {
    return remoteDataSource
        .verify(body: body, type: VerificationType.register)
        .toResult(authModelFromJson, fullParse: true);
  }

  Result<String> _verifyPhone(BodyMap body) async {
    return remoteDataSource
        .verify(body: body, type: VerificationType.changePhone)
        .toResult((_) => 'verified');
  }

  Result<String> _verifyForgetPassword(BodyMap body) async {
    return remoteDataSource
        .verify(body: body, type: VerificationType.forgetPassword)
        .toResult((json) {
          return json['reset_token'] as String;
        });
  }
}
