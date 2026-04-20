import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/resources/type_defs.dart';
import '../../../../../../core/utils/compress_util.dart';

class ProviderRegisterRequestModel extends Equatable {
  const ProviderRegisterRequestModel({
    required this.name,
    required this.phone,
    required this.commercialRegister,
    required this.password,
    required this.confirmPassword,
    this.storeNameAr,
    this.storeNameEn,
    this.storeCategory,
    this.whatsapp,
    this.logo,
    this.address,
    this.lat,
    this.long,
  });

  final String name;
  final String phone;
  final String commercialRegister;
  final String password;
  final String confirmPassword;
  final String? storeNameAr;
  final String? storeNameEn;
  final String? storeCategory;
  final String? whatsapp;
  final File? logo;
  final String? address;
  final double? lat;
  final double? long;

  ProviderRegisterRequestModel copyWith({
    String? name,
    String? phone,
    String? commercialRegister,
    String? password,
    String? confirmPassword,
    String? storeNameAr,
    String? storeNameEn,
    String? storeCategory,
    String? whatsapp,
    File? logo,
    String? address,
    double? lat,
    double? long,
  }) {
    return ProviderRegisterRequestModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      storeNameAr: storeNameAr ?? this.storeNameAr,
      storeNameEn: storeNameEn ?? this.storeNameEn,
      storeCategory: storeCategory ?? this.storeCategory,
      whatsapp: whatsapp ?? this.whatsapp,
      logo: logo ?? this.logo,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Future<BodyMap> toBody(String preferredLocale) async {
    final MultipartFile? logoFile = await CompressUtil.compress(logo);
    return {
      'username_type': 'phone',
      'name': name,
      'username': phone,
      'commercial_register': commercialRegister,
      'store_name_ar': storeNameAr,
      'store_name_en': storeNameEn,
      'store_category': storeCategory,
      'address': address,
      'whatsapp': whatsapp,
      'lat': lat?.toString(),
      'long': long?.toString(),
      'password': password,
      'password_confirmation': confirmPassword,
      'logo': logoFile,
      'device_token': 'test',
      'preferred_locale': preferredLocale,
    };
  }

  @override
  List<Object?> get props => [
        name,
        phone,
        commercialRegister,
        password,
        confirmPassword,
        storeNameAr,
        storeNameEn,
        storeCategory,
        whatsapp,
        logo?.path,
        address,
        lat,
        long,
      ];
}
