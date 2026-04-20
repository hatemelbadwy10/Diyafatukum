import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/provider_home_remote_datasource.dart';
import '../model/provider_home_model.dart';

abstract class ProviderHomeRepository {
  Result<ProviderHomeModel> getHomeData();
}

@LazySingleton(as: ProviderHomeRepository)
class ProviderHomeRepositoryImpl implements ProviderHomeRepository {
  const ProviderHomeRepositoryImpl(this.remoteDataSource);

  final ProviderHomeRemoteDataSource remoteDataSource;

  @override
  Result<ProviderHomeModel> getHomeData() async {
    return remoteDataSource.getHomeData().toResult(
      (json) => ProviderHomeModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
