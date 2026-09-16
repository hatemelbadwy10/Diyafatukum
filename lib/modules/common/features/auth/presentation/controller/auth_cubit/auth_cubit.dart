import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../addresses/data/model/address_model.dart';
import '../../../../profile/data/model/user_model.dart';
import '../../../../profile/data/repository/profile_repository.dart';
import '../../../../notifications/data/model/device_token_request.dart';
import '../../../../notifications/data/repository/notifications_repository.dart';
import '../../../data/model/auth_model.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../../../../../core/utils/notifications.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final ProfileRepository _accountRepository;
  final NotificationsRepository _notificationsRepository;
  StreamSubscription<String>? _tokenRefreshSubscription;

  AuthCubit(
    this._repository,
    this._accountRepository,
    this._notificationsRepository,
  ) : super(
        (() {
          final authModel = _repository.getAuthData();
          if (authModel == null) {
            return const AuthState();
          }
          if (authModel == const AuthModel.guest()) {
            return const AuthState(
              auth: AuthModel.guest(),
              status: AuthStatus.guest,
            );
          }
          return AuthState(auth: authModel, status: AuthStatus.authorized);
        })(),
      ) {
    _tokenRefreshSubscription = RemoteNotificationServices.onTokenRefresh
        .listen((token) => unawaited(_syncDeviceToken(token)));
    if (state.status == AuthStatus.authorized) {
      unawaited(_syncDeviceToken());
    }
  }

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(status: AuthStatus.loading));
    final authModel = _repository.getAuthData();
    if (authModel == null) {
      emit(state.copyWith(status: AuthStatus.unauthorized));
      return;
    }
    if (authModel == const AuthModel.guest()) {
      emit(state.copyWith(auth: authModel, status: AuthStatus.guest));
      return;
    }
    final result = await _accountRepository.getProfile();
    result.fold(
      (error) {
        emit(state.copyWith(status: AuthStatus.unauthorized));
        _repository.clearUserData();
      },
      (response) {
        final updatedAuthModel = authModel.copyWith(user: response.data);
        updateAuthData(updatedAuthModel);
      },
    );
  }

  void updateAuthData(AuthModel authModel) {
    sl<ApiClient>().updateToken(
      authModel == const AuthModel.guest() ? null : authModel.accessToken,
    );
    _repository.saveUserData(authModel);
    final status = authModel == const AuthModel.guest()
        ? AuthStatus.guest
        : AuthStatus.authorized;
    emit(state.copyWith(auth: authModel, status: status));
    if (status == AuthStatus.authorized) {
      unawaited(_syncDeviceToken());
    }
  }

  Future<void> _syncDeviceToken([String? refreshedToken]) async {
    if (state.status != AuthStatus.authorized) return;

    final token =
        refreshedToken ?? await RemoteNotificationServices.getFcmToken();
    if (token == null || token.trim().isEmpty) return;

    final result = await _notificationsRepository.updateDeviceToken(
      DeviceTokenRequest(deviceToken: token),
    );
    result.fold(
      (failure) =>
          log('Failed to update device token: ${failure.message}', name: 'FCM'),
      (_) => log('Device token updated successfully.', name: 'FCM'),
    );
  }

  void updateUserData(UserModel user) {
    final authModel = state.auth.copyWith(user: user);
    updateAuthData(authModel);
  }

  void updateUserAddress(AddressModel address) {
    final updatedUser = state.auth.user.copyWith(address: address);
    updateUserData(updatedUser);
  }

  void updateUserCartStoreId(int? cartStoreId) {
    final updatedUser = state.auth.user.copyWith(cartStoreId: cartStoreId);
    updateUserData(updatedUser);
  }

  void deleteUserAddress() {
    final updatedUser = state.auth.user.copyWith(address: null);
    updateUserData(updatedUser);
  }

  Future<void> logout() async {
    _repository.logout();
    _repository.clearUserData();
    emit(const AuthState());
  }

  void clearAuthData() {
    _repository.clearUserData();
    emit(const AuthState());
  }

  @override
  Future<void> close() async {
    await _tokenRefreshSubscription?.cancel();
    return super.close();
  }
}
