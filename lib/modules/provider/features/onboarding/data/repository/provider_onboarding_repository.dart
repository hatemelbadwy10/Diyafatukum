import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/data/models/base_response.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../datasource/provider_onboarding_remote_datasource.dart';

abstract class ProviderOnboardingRepository {
  Result register(BodyMap body);
}

@LazySingleton(as: ProviderOnboardingRepository)
class ProviderOnboardingRepositoryImpl
    implements ProviderOnboardingRepository {
  const ProviderOnboardingRepositoryImpl(this.remoteDataSource);

  final ProviderOnboardingRemoteDataSource remoteDataSource;

  @override
  Result<Unit> register(BodyMap body) async {
    return remoteDataSource.register(body).toResult(noDataFromJson);
  }
}
