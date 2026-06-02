import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/data/error/error_handler.dart';
import '../../../../../../core/resources/type_defs.dart';
import '../../../../../common/features/auth/data/model/register_response_model.dart';
import '../model/provider_specialization_model.dart';
import '../datasource/provider_onboarding_remote_datasource.dart';

abstract class ProviderOnboardingRepository {
  Result<RegisterResponseModel> register(FormData body);
  Result<List<ProviderSpecializationModel>> getSpecializations();
}

@LazySingleton(as: ProviderOnboardingRepository)
class ProviderOnboardingRepositoryImpl implements ProviderOnboardingRepository {
  const ProviderOnboardingRepositoryImpl(this.remoteDataSource);

  final ProviderOnboardingRemoteDataSource remoteDataSource;

  @override
  Result<RegisterResponseModel> register(FormData body) async {
    return remoteDataSource
        .register(body)
        .toResult(registerResponseModelFromJson);
  }

  @override
  Result<List<ProviderSpecializationModel>> getSpecializations() async {
    return remoteDataSource.getSpecializations().toResult(
      providerSpecializationsFromJson,
    );
  }
}
