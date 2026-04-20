import 'package:injectable/injectable.dart';

import '../../../../../../../core/data/error/error_handler.dart';
import '../../../../../../../core/resources/type_defs.dart';
import '../datasource/single_service_remote_datasource.dart';
import '../model/single_service_model.dart';
import '../model/single_service_store_model.dart';

abstract class SingleServiceRepository {
  Result<SingleServiceModel> getService(String serviceKey, ParamsMap params);
  Result<SingleServiceStoreDetailsModel> getStore(
    String serviceKey,
    String storeId,
    ParamsMap params,
  );
}

@LazySingleton(as: SingleServiceRepository)
class SingleServiceRepositoryImpl implements SingleServiceRepository {
  const SingleServiceRepositoryImpl(this.remoteDataSource);

  final SingleServiceRemoteDataSource remoteDataSource;

  @override
  Result<SingleServiceModel> getService(String serviceKey, ParamsMap params) {
    return remoteDataSource.getService(serviceKey, params).toResult(
      singleServiceFromJson,
    );
  }

  @override
  Result<SingleServiceStoreDetailsModel> getStore(
    String serviceKey,
    String storeId,
    ParamsMap params,
  ) {
    return remoteDataSource.getStore(serviceKey, storeId, params).toResult(
      singleServiceStoreDetailsFromJson,
    );
  }
}
