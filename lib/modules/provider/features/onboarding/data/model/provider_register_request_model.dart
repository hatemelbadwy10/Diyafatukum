import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/compress_util.dart';

class ProviderRegisterRequestModel extends Equatable {
  const ProviderRegisterRequestModel({
    required this.name,
    required this.phone,
    required this.commercialRegister,
    required this.password,
    required this.confirmPassword,
    this.specializationId,
    this.storeNameAr,
    this.storeNameEn,
    this.storeDescriptionAr,
    this.storeDescriptionEn,
    this.whatsapp,
    this.logo,
    this.address,
    this.latitude,
    this.longitude,
  });

  final String name;
  final String phone;
  final String commercialRegister;
  final String password;
  final String confirmPassword;
  final String? specializationId;
  final String? storeNameAr;
  final String? storeNameEn;
  final String? storeDescriptionAr;
  final String? storeDescriptionEn;
  final String? whatsapp;
  final File? logo;
  final String? address;
  final double? latitude;
  final double? longitude;

  ProviderRegisterRequestModel copyWith({
    String? name,
    String? phone,
    String? commercialRegister,
    String? password,
    String? confirmPassword,
    String? specializationId,
    String? storeNameAr,
    String? storeNameEn,
    String? storeDescriptionAr,
    String? storeDescriptionEn,
    String? whatsapp,
    File? logo,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return ProviderRegisterRequestModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      specializationId: specializationId ?? this.specializationId,
      storeNameAr: storeNameAr ?? this.storeNameAr,
      storeNameEn: storeNameEn ?? this.storeNameEn,
      storeDescriptionAr: storeDescriptionAr ?? this.storeDescriptionAr,
      storeDescriptionEn: storeDescriptionEn ?? this.storeDescriptionEn,
      whatsapp: whatsapp ?? this.whatsapp,
      logo: logo ?? this.logo,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Future<FormData> toBody() async {
    final MultipartFile? logoFile = await CompressUtil.compress(logo);
    return FormData.fromMap({
      'name': name,
      'phone': phone,
      'commercial_registration_number': commercialRegister,
      'specialization_id': specializationId,
      'address': address,
      'latitude': latitude?.toString(),
      'longitude': longitude?.toString(),
      'whatsapp': whatsapp,
      'ar[store_name]': storeNameAr,
      'ar[store_description]': storeDescriptionAr,
      'en[store_name]': storeNameEn,
      'en[store_description]': storeDescriptionEn,
      'password': password,
      'password_confirmation': confirmPassword,
      'accept_terms': '1',
      'logo': logoFile,
    });
  }

  @override
  List<Object?> get props => [
    name,
    phone,
    commercialRegister,
    password,
    confirmPassword,
    specializationId,
    storeNameAr,
    storeNameEn,
    storeDescriptionAr,
    storeDescriptionEn,
    whatsapp,
    logo?.path,
    address,
    latitude,
    longitude,
  ];
}
