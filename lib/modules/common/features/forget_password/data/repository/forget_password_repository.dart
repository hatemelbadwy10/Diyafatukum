import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';

import '../../../../../../core/data/models/base_response.dart';

import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/forget_password_remote_datasource.dart';

abstract class ForgetPasswordRepository {
  Result forgetPassword(String phone);
  Result resetPassword(BodyMap body);
}

@LazySingleton(as: ForgetPasswordRepository)
class ForgetPasswordRepositoryImpl implements ForgetPasswordRepository {
  final ForgetPasswordRemoteDataSource remoteDataSource;
  const ForgetPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Result forgetPassword(String phone) {
    return remoteDataSource.forgetPassword(phone).toResult(noDataFromJson);
  }

  @override
  Result resetPassword(BodyMap body) {
    return remoteDataSource.resetPassword(body).toResult(noDataFromJson);
  }
}
