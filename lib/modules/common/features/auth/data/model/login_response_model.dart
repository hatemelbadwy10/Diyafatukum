import 'package:equatable/equatable.dart';

import 'auth_model.dart';

LoginResponseModel loginResponseModelFromJson(dynamic json) =>
    LoginResponseModel.fromJson(Map<String, dynamic>.from(json as Map));

class LoginResponseModel extends Equatable {
  const LoginResponseModel({
    this.auth,
    this.identifier,
    this.otp,
    this.verified = true,
  });

  final AuthModel? auth;
  final String? identifier;
  final String? otp;
  final bool verified;

  bool get requiresVerification => !verified && (identifier?.isNotEmpty ?? false);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final hasAuthPayload = json.containsKey('token') && json.containsKey('user');

    return LoginResponseModel(
      auth: hasAuthPayload ? authModelFromJson(json) : null,
      identifier: json['identifier']?.toString(),
      otp: json['otp']?.toString(),
      verified: json['verified'] as bool? ?? hasAuthPayload,
    );
  }

  @override
  List<Object?> get props => [auth, identifier, otp, verified];
}
