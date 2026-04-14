import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/resources/constants/pref_keys.dart';
import '../model/auth_model.dart';



abstract class AuthLocalDataSource {
  Future<void> saveAuthData(AuthModel authModel);
  AuthModel? getAuthData();
  void clearUserData();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveAuthData(AuthModel authModel) async {
    await sharedPreferences.setString(PrefKeys.auth, jsonEncode(authModel.toJson()));
  }

  @override
  AuthModel? getAuthData() {
    final authData = sharedPreferences.getString(PrefKeys.auth);
    if (authData != null) {
      return AuthModel.fromJson(jsonDecode(authData));
    }
    return null;
  }

  @override
  void clearUserData() {
    sharedPreferences.remove(PrefKeys.auth);
  }
}
