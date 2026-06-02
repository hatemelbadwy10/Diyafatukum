import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utils/compress_util.dart';
import 'provider_store_model.dart';

class ProviderStoreCategoryRequestModel extends Equatable {
  const ProviderStoreCategoryRequestModel({
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.sortOrder = 1,
    this.active = true,
  });

  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final int sortOrder;
  final bool active;

  Map<String, dynamic> toBody() {
    return {
      'sort_order': sortOrder,
      'active': active,
      'ar': {'name': nameAr, 'description': descriptionAr},
      'en': {'name': nameEn, 'description': descriptionEn},
    };
  }

  ProviderStoreCategoryModel toCategory({required String id}) {
    return ProviderStoreCategoryModel(
      id: id,
      name: nameAr.isNotEmpty ? nameAr : nameEn,
    );
  }

  @override
  List<Object?> get props => [
    nameAr,
    nameEn,
    descriptionAr,
    descriptionEn,
    sortOrder,
    active,
  ];
}

class ProviderStoreProductRequestModel extends Equatable {
  const ProviderStoreProductRequestModel({
    required this.storeCategoryId,
    required this.price,
    required this.quantity,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.image,
  });

  final String storeCategoryId;
  final String price;
  final String quantity;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final File? image;

  Future<FormData> toFormData() async {
    final imageFile = await CompressUtil.compress(image);
    return FormData.fromMap({
      'store_category_id': storeCategoryId,
      'price': price,
      'quantity': quantity,
      'ar[name]': nameAr,
      'ar[description]': descriptionAr,
      'en[name]': nameEn,
      'en[description]': descriptionEn,
      if (imageFile != null) 'image': imageFile,
    });
  }

  ProviderStoreProductModel toProduct({
    required String id,
    required String categoryName,
    String? imagePath,
  }) {
    return ProviderStoreProductModel(
      id: id,
      categoryId: storeCategoryId,
      categoryName: categoryName,
      name: nameAr.isNotEmpty ? nameAr : nameEn,
      description: descriptionAr.isNotEmpty ? descriptionAr : descriptionEn,
      price: double.tryParse(price) ?? 0,
      imagePath: imagePath ?? image?.path ?? '',
      quantity: int.tryParse(quantity) ?? 0,
      inStock: (int.tryParse(quantity) ?? 0) > 0,
    );
  }

  @override
  List<Object?> get props => [
    storeCategoryId,
    price,
    quantity,
    nameAr,
    nameEn,
    descriptionAr,
    descriptionEn,
    image?.path,
  ];
}

class ProviderStoreUpdateRequestModel extends Equatable {
  const ProviderStoreUpdateRequestModel({
    required this.phone,
    required this.commercialRegistrationNumber,
    required this.specializationId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.whatsapp,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.logo,
  });

  final String phone;
  final String commercialRegistrationNumber;
  final String specializationId;
  final String address;
  final String latitude;
  final String longitude;
  final String whatsapp;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final File? logo;

  Future<FormData> toFormData() async {
    final logoFile = await CompressUtil.compress(logo);
    return FormData.fromMap({
      'phone': phone,
      'commercial_registration_number': commercialRegistrationNumber,
      'specialization_id': specializationId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'whatsapp': whatsapp,
      'ar[name]': nameAr,
      'ar[description]': descriptionAr,
      'en[name]': nameEn,
      'en[description]': descriptionEn,
      if (logoFile != null) 'logo': logoFile,
    });
  }

  ProviderStoreModel applyToStore(ProviderStoreModel store) {
    return store.copyWith(
      name: nameAr,
      nameEn: nameEn,
      location: address,
      coverImagePath: logo?.path ?? store.coverImagePath,
      whatsapp: whatsapp,
      phone: phone,
      commercialRegistrationNumber: commercialRegistrationNumber,
      latitude: latitude,
      longitude: longitude,
    );
  }

  @override
  List<Object?> get props => [
    phone,
    commercialRegistrationNumber,
    specializationId,
    address,
    latitude,
    longitude,
    whatsapp,
    nameAr,
    nameEn,
    descriptionAr,
    descriptionEn,
    logo?.path,
  ];
}

class ProviderStoreDescriptionRequestModel extends Equatable {
  const ProviderStoreDescriptionRequestModel({
    required this.descriptionAr,
    required this.descriptionEn,
  });

  final String descriptionAr;
  final String descriptionEn;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'ar[description]': descriptionAr,
      'en[description]': descriptionEn,
    });
  }

  ProviderStoreModel applyToStore(ProviderStoreModel store) {
    return store.copyWith(
      aboutDescription:
          descriptionAr.isNotEmpty ? descriptionAr : descriptionEn,
    );
  }

  @override
  List<Object?> get props => [descriptionAr, descriptionEn];
}
