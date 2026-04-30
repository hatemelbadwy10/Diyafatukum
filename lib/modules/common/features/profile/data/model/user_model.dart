import 'package:equatable/equatable.dart';

import '../../../../../../../core/resources/resources.dart';
import '../../../addresses/data/model/address_model.dart';

UserModel userModelFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    final nestedUser = json['user'];
    if (nestedUser is Map<String, dynamic>) {
      return UserModel.fromJson(nestedUser);
    }
    return UserModel.fromJson(json);
  }
  return const UserModel.guest();
}

class UserModel extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String avatar;
  final bool isPhoneVerified;
  final bool notificationEnabled;
  final String addressText;
  final AddressModel? address;

  bool get hasDefaultAddress => address != null;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.avatar,
    required this.isPhoneVerified,
    required this.notificationEnabled,
    required this.addressText,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final addressJson = json['address'];
    final hasStructuredAddress = addressJson is Map<String, dynamic>;
    final phoneVerifiedValue =
        json['phone_verified'] ?? json['is_phone_verified'];
    final addressText = _resolveAddressText(
      json,
      addressJson,
      hasStructuredAddress,
    );

    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      isPhoneVerified: phoneVerifiedValue == null
          ? true
          : phoneVerifiedValue == true || phoneVerifiedValue == 1,
      notificationEnabled:
          json['notification_enabled'] == true ||
          json['notification_enabled'] == 1,
      avatar: json['avatar'] ?? '',
      addressText: addressText,
      address: hasStructuredAddress
          ? AddressModel.fromJson(addressJson)
          : _buildAddressModel(
              addressText: addressText,
              latitude: json['latitude'],
              longitude: json['longitude'],
            ),
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
      'notification_enabled': notificationEnabled,
      'address_text': addressText,
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
    bool? notificationEnabled,
    String? addressText,
    Object? address = _noValue,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      addressText: addressText ?? this.addressText,
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
      notificationEnabled = false,
      avatar = '',
      addressText = '',
      address = null;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    isPhoneVerified,
    notificationEnabled,
    avatar,
    addressText,
    address,
  ];
}

String _resolveAddressText(
  Map<String, dynamic> json,
  dynamic addressJson,
  bool hasStructuredAddress,
) {
  if (hasStructuredAddress) {
    return json['address_text']?.toString() ?? '';
  }

  if (addressJson is String && addressJson.isNotEmpty) {
    return addressJson;
  }

  return json['address_text']?.toString() ?? '';
}

AddressModel? _buildAddressModel({
  required String addressText,
  dynamic latitude,
  dynamic longitude,
}) {
  if (addressText.isEmpty) return null;

  final area = addressText
      .split(',')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();

  return const AddressModel.empty().copyWith(
    label: addressText,
    area: area.length >= 2 ? area[area.length - 2] : area.first,
    lat: double.tryParse(latitude?.toString() ?? '') ?? 0,
    lng: double.tryParse(longitude?.toString() ?? '') ?? 0,
  );
}
