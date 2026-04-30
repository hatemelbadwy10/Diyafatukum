import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/provider_store_remote_datasource.dart';
import '../model/provider_store_model.dart';

abstract class ProviderStoreRepository {
  Result<ProviderStoreModel> getStore();
}

@LazySingleton(as: ProviderStoreRepository)
class ProviderStoreRepositoryImpl implements ProviderStoreRepository {
  const ProviderStoreRepositoryImpl(this.remoteDataSource);

  final ProviderStoreRemoteDataSource remoteDataSource;

  @override
  Result<ProviderStoreModel> getStore() {
    return remoteDataSource.getStore().toResult(providerStoreFromJson);
  }
}
