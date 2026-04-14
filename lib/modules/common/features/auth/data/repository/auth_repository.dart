import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../core/data/client/api_client.dart';
import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/auth_local_data_source.dart';
import '../datasource/auth_remote_datasource.dart';
import '../model/auth_model.dart';

abstract class AuthRepository {
  Result register(BodyMap body);
  Result<AuthModel> login(BodyMap body);
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
  Result<Unit> register(BodyMap body) async {
    return remoteDataSource.register(body).toResult(noDataFromJson);
  }

  @override
  Result<AuthModel> login(BodyMap body) async {
    return remoteDataSource.login(body).toResult(authModelFromJson, fullParse: true);
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
