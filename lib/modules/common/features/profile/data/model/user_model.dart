import 'package:equatable/equatable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../addresses/data/model/address_model.dart';

UserModel userModelFromJson(dynamic json) => UserModel.fromJson(json);

class UserModel extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String avatar;
  final bool isPhoneVerified;
  final AddressModel? address;

  bool get hasDefaultAddress => address != null;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.avatar,
    required this.isPhoneVerified,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      isPhoneVerified: json['phone_verified'],
      avatar: json['avatar'],
      address: json['address'] != null ? AddressModel.fromJson(json['address']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'phone_verified': isPhoneVerified,
      'address': address?.toJson(),
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    bool? isPhoneVerified,
    Object? address = _noValue,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      address: address == _noValue ? this.address : address as AddressModel?,
    );
  }

  static const _noValue = Object();

  const UserModel.guest()
      : id = 0,
        name = LocaleKeys.auth_guest_title,
        email = null,
        phone = '',
        isPhoneVerified = false,
        avatar = '',
        address = null;

  @override
  List<Object?> get props => [id, name, email, phone, isPhoneVerified, avatar, address];
}
