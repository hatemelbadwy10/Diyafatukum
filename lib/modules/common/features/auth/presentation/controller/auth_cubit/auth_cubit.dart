import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../../core/config/service_locator/injection.dart';
import '../../../../../../../core/data/client/api_client.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../addresses/data/model/address_model.dart';
import '../../../../profile/data/model/user_model.dart';
import '../../../../profile/data/repository/profile_repository.dart';
import '../../../data/model/auth_model.dart';
import '../../../data/repository/auth_repository.dart';

part 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final ProfileRepository _accountRepository;
  AuthCubit(this._repository, this._accountRepository) : super(const AuthState());

  Future<void> checkAuthStatus() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(status: AuthStatus.loading));
    final authModel = _repository.getAuthData();
    if (authModel != null) {
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
    } else {
      emit(state.copyWith(status: AuthStatus.unauthorized));
    }
  }

  void updateAuthData(AuthModel authModel) {
    sl<ApiClient>().updateToken(authModel.accessToken);
    _repository.saveUserData(authModel);
    final status = authModel == const AuthModel.guest() ? AuthStatus.unauthorized : AuthStatus.authorized;
    emit(state.copyWith(auth: authModel, status: status));
  }

  void updateUserData(UserModel user) {
    final authModel = state.auth.copyWith(user: user);
    updateAuthData(authModel);
  }

  void updateUserAddress(AddressModel address) {
    final updatedUser = state.auth.user.copyWith(address: address);
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
}
