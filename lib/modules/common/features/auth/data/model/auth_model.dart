import 'package:equatable/equatable.dart';

import '../../../profile/data/model/user_model.dart';

AuthModel authModelFromJson(dynamic json) => AuthModel.fromJson(json);

class AuthModel extends Equatable {
  const AuthModel({required this.user, this.accessToken});

  final UserModel user;
  final String? accessToken;

  bool get isVerified => user.isPhoneVerified;

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': accessToken};
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: userModelFromJson(json['user'] ?? json['data']),
      accessToken: json["token"],
    );
  }

  AuthModel copyWith({UserModel? user, String? accessToken}) {
    return AuthModel(user: user ?? this.user, accessToken: accessToken ?? this.accessToken);
  }

  const AuthModel.guest() : user = const UserModel.guest(), accessToken = '';

  bool get isEmpty => this == const AuthModel.guest();

  @override
  List<Object?> get props => [user, accessToken];
}
