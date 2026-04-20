// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../../modules/common/features/addresses/data/datasource/addresses_remote_datasource.dart'
    as _i514;
import '../../../modules/common/features/addresses/data/repository/addresses_repository.dart'
    as _i601;
import '../../../modules/common/features/addresses/presentation/controller/add_address_cubit/add_address_cubit.dart'
    as _i32;
import '../../../modules/common/features/addresses/presentation/controller/address_cubit/address_cubit.dart'
    as _i686;
import '../../../modules/common/features/addresses/presentation/controller/addresses_cubit/addresses_cubit.dart'
    as _i334;
import '../../../modules/common/features/addresses/presentation/controller/default_address_cubit/default_address_cubit.dart'
    as _i966;
import '../../../modules/common/features/addresses/presentation/controller/delete_address_cubit/delete_address_cubit.dart'
    as _i312;
import '../../../modules/common/features/auth/data/datasource/auth_local_data_source.dart'
    as _i493;
import '../../../modules/common/features/auth/data/datasource/auth_remote_datasource.dart'
    as _i299;
import '../../../modules/common/features/auth/data/repository/auth_repository.dart'
    as _i1056;
import '../../../modules/common/features/auth/presentation/controller/auth_cubit/auth_cubit.dart'
    as _i1067;
import '../../../modules/common/features/auth/presentation/controller/login_cubit/login_cubit.dart'
    as _i621;
import '../../../modules/common/features/auth/presentation/controller/register_cubit/register_cubit.dart'
    as _i685;
import '../../../modules/common/features/bag/data/datasource/bag_local_datasource.dart'
    as _i370;
import '../../../modules/common/features/bag/data/repository/bag_repository.dart'
    as _i217;
import '../../../modules/common/features/bag/presentation/controller/bag_cubit/bag_cubit.dart'
    as _i395;
import '../../../modules/common/features/forget_password/data/datasource/forget_password_remote_datasource.dart'
    as _i1013;
import '../../../modules/common/features/forget_password/data/repository/forget_password_repository.dart'
    as _i30;
import '../../../modules/common/features/forget_password/presentation/controller/forget_password_cubit/forget_password_cubit.dart'
    as _i410;
import '../../../modules/common/features/forget_password/presentation/controller/reset_password_cubit/reset_password_cubit.dart'
    as _i1028;
import '../../../modules/common/features/notifications/data/datasource/notifications_remote_datasource.dart'
    as _i656;
import '../../../modules/common/features/notifications/data/repository/notifications_repository.dart'
    as _i827;
import '../../../modules/common/features/orders/data/datasource/orders_remote_datasource.dart'
    as _i681;
import '../../../modules/common/features/orders/data/repository/orders_repository.dart'
    as _i1015;
import '../../../modules/common/features/orders/presentation/controller/orders_cubit/orders_cubit.dart'
    as _i775;
import '../../../modules/common/features/profile/data/datasource/profile_remote_datasource.dart'
    as _i858;
import '../../../modules/common/features/profile/data/repository/profile_repository.dart'
    as _i821;
import '../../../modules/common/features/profile/presentation/controller/delete_account_cubit/delete_account_cubit.dart'
    as _i327;
import '../../../modules/common/features/profile/presentation/controller/password_cubit/password_cubit.dart'
    as _i191;
import '../../../modules/common/features/profile/presentation/controller/phone_cubit/phone_cubit.dart'
    as _i322;
import '../../../modules/common/features/profile/presentation/controller/profile_cubit/profile_cubit.dart'
    as _i115;
import '../../../modules/common/features/settings/data/datasource/settings_remote_datasource.dart'
    as _i903;
import '../../../modules/common/features/settings/data/repository/settings_repository.dart'
    as _i633;
import '../../../modules/common/features/settings/presentation/controller/contact_us_cubit/contact_us_cubit.dart'
    as _i216;
import '../../../modules/common/features/settings/presentation/controller/contacts_cubit/contacts_cubit.dart'
    as _i477;
import '../../../modules/common/features/settings/presentation/controller/language_cubit/language_cubit.dart'
    as _i853;
import '../../../modules/common/features/settings/presentation/controller/static_page_cubit/static_page_cubit.dart'
    as _i458;
import '../../../modules/common/features/shared/data/datasources/shared_remote_datasource.dart'
    as _i235;
import '../../../modules/common/features/shared/data/repository/shared_repository.dart'
    as _i856;
import '../../../modules/common/features/splash/data/datasource/splash_local_datasource.dart'
    as _i78;
import '../../../modules/common/features/splash/data/datasource/splash_remote_datasource.dart'
    as _i933;
import '../../../modules/common/features/splash/data/repository/splash_repository.dart'
    as _i505;
import '../../../modules/common/features/splash/presentation/controller/splash_cubit.dart'
    as _i502;
import '../../../modules/common/features/verification/data/datasource/verification_remote_datasource.dart'
    as _i248;
import '../../../modules/common/features/verification/data/repository/verification_repository.dart'
    as _i66;
import '../../../modules/common/features/verification/presentation/controller/verification_cubit/verification_cubit.dart'
    as _i269;
import '../../../modules/provider/features/home/data/datasource/provider_home_remote_datasource.dart'
    as _i540;
import '../../../modules/provider/features/home/data/repository/provider_home_repository.dart'
    as _i634;
import '../../../modules/provider/features/home/presentation/controller/provider_home_cubit/provider_home_cubit.dart'
    as _i805;
import '../../../modules/provider/features/onboarding/data/datasource/provider_onboarding_remote_datasource.dart'
    as _i751;
import '../../../modules/provider/features/onboarding/data/repository/provider_onboarding_repository.dart'
    as _i581;
import '../../../modules/provider/features/onboarding/presentation/controller/provider_register_cubit/provider_register_cubit.dart'
    as _i412;
import '../../../modules/user/features/home/data/datasource/user_home_remote_datasource.dart'
    as _i523;
import '../../../modules/user/features/home/data/repository/user_home_repository.dart'
    as _i245;
import '../../../modules/user/features/home/presentation/controller/user_home_cubit/user_home_cubit.dart'
    as _i785;
import '../../../modules/user/features/single_service/data/datasource/single_service_remote_datasource.dart'
    as _i340;
import '../../../modules/user/features/single_service/data/repository/single_service_repository.dart'
    as _i665;
import '../../../modules/user/features/single_service/presentation/controller/single_service_cubit/single_service_cubit.dart'
    as _i340;
import '../../../modules/user/features/single_service/presentation/controller/single_service_store_cubit/single_service_store_cubit.dart'
    as _i965;
import '../../data/client/api_client.dart' as _i897;
import '../../data/client/logger_interceptor.dart' as _i891;
import '../../utils/location_utils.dart' as _i494;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.pref,
    preResolve: true,
  );
  gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
  gh.lazySingleton<_i558.FlutterSecureStorage>(
    () => registerModule.secureStorage,
  );
  gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
  gh.lazySingleton<_i891.LoggerInterceptor>(() => _i891.LoggerInterceptor());
  gh.lazySingleton<_i494.LocationService>(() => _i494.LocationServiceImpl());
  gh.lazySingleton<_i856.SharedRepository>(
    () => const _i856.SharedRepositoryImpl(),
  );
  gh.lazySingleton<_i897.ApiClient>(
    () => _i897.ApiClient(
      gh<_i361.Dio>(),
      loggingInterceptor: gh<_i891.LoggerInterceptor>(),
    ),
  );
  gh.lazySingleton<_i1013.ForgetPasswordRemoteDataSource>(
    () => _i1013.ForgetPasswordRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i248.VerificationRemoteDataSource>(
    () => _i248.VerificationRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i514.AddressesRemoteDataSource>(
    () => _i514.AddressesRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i903.SettingsRemoteDataSource>(
    () => _i903.AccountRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i235.SharedRemoteDatasource>(
    () => _i235.SharedRemoteDatasourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i601.AddressesRepository>(
    () => _i601.AddressesRepositoryImpl(gh<_i514.AddressesRemoteDataSource>()),
  );
  gh.lazySingleton<_i78.SplashLocalDatasource>(
    () => _i78.SplashLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i370.BagLocalDataSource>(
    () => _i370.BagLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i493.AuthLocalDataSource>(
    () => _i493.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
  );
  gh.lazySingleton<_i66.VerificationRepository>(
    () => _i66.VerificationRepositoryImpl(
      gh<_i248.VerificationRemoteDataSource>(),
    ),
  );
  gh.factory<_i269.VerificationCubit>(
    () => _i269.VerificationCubit(gh<_i66.VerificationRepository>()),
  );
  gh.lazySingleton<_i633.SettingsRepository>(
    () => _i633.SettingsRepositoryImpl(gh<_i903.SettingsRemoteDataSource>()),
  );
  gh.factory<_i686.AddressCubit>(
    () => _i686.AddressCubit(gh<_i601.AddressesRepository>()),
  );
  gh.factory<_i966.DefaultAddressCubit>(
    () => _i966.DefaultAddressCubit(gh<_i601.AddressesRepository>()),
  );
  gh.factory<_i334.AddressesCubit>(
    () => _i334.AddressesCubit(gh<_i601.AddressesRepository>()),
  );
  gh.factory<_i32.AddAddressCubit>(
    () => _i32.AddAddressCubit(gh<_i601.AddressesRepository>()),
  );
  gh.factory<_i312.DeleteAddressCubit>(
    () => _i312.DeleteAddressCubit(gh<_i601.AddressesRepository>()),
  );
  gh.lazySingleton<_i681.OrdersRemoteDataSource>(
    () => _i681.OrdersRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i30.ForgetPasswordRepository>(
    () => _i30.ForgetPasswordRepositoryImpl(
      gh<_i1013.ForgetPasswordRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i523.UserHomeRemoteDataSource>(
    () => _i523.UserHomeRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i340.SingleServiceRemoteDataSource>(
    () => _i340.SingleServiceRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i751.ProviderOnboardingRemoteDataSource>(
    () => _i751.ProviderOnboardingRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i217.BagRepository>(
    () => _i217.BagRepositoryImpl(gh<_i370.BagLocalDataSource>()),
  );
  gh.factory<_i216.ContactUsCubit>(
    () => _i216.ContactUsCubit(gh<_i633.SettingsRepository>()),
  );
  gh.factory<_i458.StaticPageCubit>(
    () => _i458.StaticPageCubit(gh<_i633.SettingsRepository>()),
  );
  gh.factory<_i477.ContactsCubit>(
    () => _i477.ContactsCubit(gh<_i633.SettingsRepository>()),
  );
  gh.lazySingleton<_i540.ProviderHomeRemoteDataSource>(
    () => _i540.ProviderHomeRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i933.SplashRemoteDataSource>(
    () => _i933.SplashRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i858.ProfileRemoteDataSource>(
    () => _i858.ProfileRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i299.AuthRemoteDataSource>(
    () => _i299.AuthRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i656.NotificationsRemoteDataSource>(
    () => _i656.NotificationsRemoteDataSourceImpl(gh<_i897.ApiClient>()),
  );
  gh.lazySingleton<_i505.SplashRepository>(
    () => _i505.SplashRepositoryImpl(
      gh<_i933.SplashRemoteDataSource>(),
      gh<_i78.SplashLocalDatasource>(),
    ),
  );
  gh.factory<_i410.ForgetPasswordCubit>(
    () => _i410.ForgetPasswordCubit(gh<_i30.ForgetPasswordRepository>()),
  );
  gh.factory<_i1028.ResetPasswordCubit>(
    () => _i1028.ResetPasswordCubit(gh<_i30.ForgetPasswordRepository>()),
  );
  gh.lazySingleton<_i634.ProviderHomeRepository>(
    () => _i634.ProviderHomeRepositoryImpl(
      gh<_i540.ProviderHomeRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i245.UserHomeRepository>(
    () => _i245.UserHomeRepositoryImpl(gh<_i523.UserHomeRemoteDataSource>()),
  );
  gh.lazySingleton<_i502.SplashCubit>(
    () => _i502.SplashCubit(gh<_i505.SplashRepository>()),
  );
  gh.lazySingleton<_i1015.OrdersRepository>(
    () => _i1015.OrdersRepositoryImpl(gh<_i681.OrdersRemoteDataSource>()),
  );
  gh.factory<_i395.BagCubit>(() => _i395.BagCubit(gh<_i217.BagRepository>()));
  gh.lazySingleton<_i827.NotificationsRepository>(
    () => _i827.NotificationsRepositoryImpl(
      gh<_i656.NotificationsRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i581.ProviderOnboardingRepository>(
    () => _i581.ProviderOnboardingRepositoryImpl(
      gh<_i751.ProviderOnboardingRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i1056.AuthRepository>(
    () => _i1056.AuthRepositoryImpl(
      gh<_i299.AuthRemoteDataSource>(),
      gh<_i493.AuthLocalDataSource>(),
    ),
  );
  gh.factory<_i775.OrdersCubit>(
    () => _i775.OrdersCubit(gh<_i1015.OrdersRepository>()),
  );
  gh.factory<_i853.LanguageCubit>(
    () => _i853.LanguageCubit(gh<_i633.SettingsRepository>()),
  );
  gh.lazySingleton<_i665.SingleServiceRepository>(
    () => _i665.SingleServiceRepositoryImpl(
      gh<_i340.SingleServiceRemoteDataSource>(),
    ),
  );
  gh.factory<_i621.LoginCubit>(
    () => _i621.LoginCubit(gh<_i1056.AuthRepository>()),
  );
  gh.factory<_i685.RegisterCubit>(
    () => _i685.RegisterCubit(gh<_i1056.AuthRepository>()),
  );
  gh.lazySingleton<_i821.ProfileRepository>(
    () => _i821.ProfileRepositoryImpl(gh<_i858.ProfileRemoteDataSource>()),
  );
  gh.factory<_i805.ProviderHomeCubit>(
    () => _i805.ProviderHomeCubit(gh<_i634.ProviderHomeRepository>()),
  );
  gh.factory<_i340.SingleServiceCubit>(
    () => _i340.SingleServiceCubit(gh<_i665.SingleServiceRepository>()),
  );
  gh.factory<_i965.SingleServiceStoreCubit>(
    () => _i965.SingleServiceStoreCubit(gh<_i665.SingleServiceRepository>()),
  );
  gh.factory<_i412.ProviderRegisterCubit>(
    () => _i412.ProviderRegisterCubit(gh<_i581.ProviderOnboardingRepository>()),
  );
  gh.factory<_i785.UserHomeCubit>(
    () => _i785.UserHomeCubit(gh<_i245.UserHomeRepository>()),
  );
  gh.lazySingleton<_i1067.AuthCubit>(
    () => _i1067.AuthCubit(
      gh<_i1056.AuthRepository>(),
      gh<_i821.ProfileRepository>(),
    ),
  );
  gh.factory<_i327.DeleteAccountCubit>(
    () => _i327.DeleteAccountCubit(gh<_i821.ProfileRepository>()),
  );
  gh.factory<_i115.ProfileCubit>(
    () => _i115.ProfileCubit(gh<_i821.ProfileRepository>()),
  );
  gh.factory<_i322.PhoneCubit>(
    () => _i322.PhoneCubit(gh<_i821.ProfileRepository>()),
  );
  gh.factory<_i191.PasswordCubit>(
    () => _i191.PasswordCubit(gh<_i821.ProfileRepository>()),
  );
  return getIt;
}

class _$RegisterModule extends _i464.RegisterModule {}
