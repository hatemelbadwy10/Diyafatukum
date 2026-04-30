import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/error/error_handler.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/user_home_remote_datasource.dart';
import '../model/user_home_model.dart';

abstract class UserHomeRepository {
  Result<UserHomeModel> getHomeData({String search = '', int limit = 10});
}

@LazySingleton(as: UserHomeRepository)
class UserHomeRepositoryImpl implements UserHomeRepository {
  const UserHomeRepositoryImpl(this.remoteDataSource);

  final UserHomeRemoteDataSource remoteDataSource;

  @override
  Result<UserHomeModel> getHomeData({String search = '', int limit = 10}) {
    return remoteDataSource.getHomeData({
      'search': search,
      'limit': limit.toString(),
    }).toResult(userHomeFromJson);
  }
}
