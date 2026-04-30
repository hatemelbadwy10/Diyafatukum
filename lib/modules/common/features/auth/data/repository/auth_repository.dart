import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/data/error/error_constants.dart';
import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import 'package:dio/dio.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/auth_local_data_source.dart';
import '../datasource/auth_remote_datasource.dart';
import '../model/auth_model.dart';
import '../model/login_response_model.dart';
import '../model/register_response_model.dart';

abstract class AuthRepository {
  Result<RegisterResponseModel> register(BodyMap body);
  Result<LoginResponseModel> login(BodyMap body);
  Result logout();

  void saveUserData(AuthModel authModel);
  void clearUserData();
  AuthModel? getAuthData();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  const AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Result<RegisterResponseModel> register(BodyMap body) async {
    return remoteDataSource.register(body).toResult(registerResponseModelFromJson);
  }

  @override
  Result<LoginResponseModel> login(BodyMap body) async {
    try {
      final response = await remoteDataSource.login(body);
      return Right(parseBaseResponse(response.data, loginResponseModelFromJson));
    } catch (e) {
      if (e is DioException && e.response?.statusCode == ResponseCode.FORBIDDEN) {
        final responseData = e.response?.data;
        if (responseData is Map<String, dynamic>) {
          final payload = responseData['payload'];
          if (payload is Map<String, dynamic> && payload['verified'] == false) {
            return Right(parseBaseResponse(responseData, loginResponseModelFromJson));
          }
        }
      }

      final failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  @override
  Result<Unit> logout() async {
    return remoteDataSource.logout().toResult(noDataFromJson);
  }

  @override
  void saveUserData(AuthModel authModel) {
    sl<ApiClient>().updateToken(authModel.accessToken);
    localDataSource.saveAuthData(authModel);
  }

  @override
  void clearUserData() {
    sl<ApiClient>().updateToken('');
    localDataSource.clearUserData();
  }

  @override
  AuthModel? getAuthData() {
    final authModel = localDataSource.getAuthData();
    if (authModel != null) sl<ApiClient>().updateToken(authModel.accessToken ?? '');
    return authModel;
  }
}
