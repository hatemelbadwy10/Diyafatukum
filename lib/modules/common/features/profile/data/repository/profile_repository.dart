import 'package:injectable/injectable.dart';

import '../../../../../../../core/resources/type_defs.dart';
import '../../../../../../core/data/error/error_handler.dart';

import '../../../../../../core/data/models/base_response.dart';

import '../datasource/profile_remote_datasource.dart';
import '../model/user_model.dart';

abstract class ProfileRepository {
  Result<UserModel> getProfile();

  Result<UserModel> updateProfile(BodyMap body);

  Result changePhone(BodyMap body);

  Result changePassword(BodyMap body);

  Result deleteAccount(String password);
}

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  const ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Result<UserModel> getProfile() async {
    return remoteDataSource.getProfile().toResult(userModelFromJson);
  }

  @override
  Result<UserModel> updateProfile(BodyMap body) async {
    return remoteDataSource.updateProfile(body).toResult(userModelFromJson);
  }

  @override
  Result changePhone(BodyMap body) async {
    return remoteDataSource.changePhone(body).toResult(noDataFromJson);
  }

  @override
  Result changePassword(BodyMap body) async {
    return remoteDataSource.changePassword(body).toResult(noDataFromJson);
  }

  @override
  Result deleteAccount(String password) async {
    return remoteDataSource.deleteAccount(password).toResult(noDataFromJson);
  }
}
