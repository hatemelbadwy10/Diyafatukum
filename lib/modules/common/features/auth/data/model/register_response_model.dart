import 'package:equatable/equatable.dart';

import '../../../profile/data/model/user_model.dart';

RegisterResponseModel registerResponseModelFromJson(dynamic json) =>
    RegisterResponseModel.fromJson(Map<String, dynamic>.from(json as Map));

class RegisterResponseModel extends Equatable {
  const RegisterResponseModel({
    required this.identifier,
    required this.userRole,
    required this.user,
    this.otp,
  });

  final String identifier;
  final String userRole;
  final UserModel user;
  final String? otp;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      identifier: json['identifier']?.toString() ?? '',
      userRole: json['user_role']?.toString() ?? '',
      user: userModelFromJson(json['user']),
      otp: json['otp']?.toString(),
    );
  }

  @override
  List<Object?> get props => [identifier, userRole, user, otp];
}
