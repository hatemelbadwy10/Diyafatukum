import 'package:equatable/equatable.dart';

ProviderStoreModel providerStoreFromJson(dynamic json) =>
    ProviderStoreModel.fromProfileJson(json as Map<String, dynamic>);

class ProviderStoreModel extends Equatable {
  const ProviderStoreModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.specializationId,
    required this.location,
    required this.coverImagePath,
    required this.aboutDescription,
    required this.aboutHighlights,
    required this.whatsapp,
    required this.phone,
    required this.commercialRegistrationNumber,
    required this.latitude,
    required this.longitude,
    required this.categories,
    required this.products,
  });

  final String id;
  final String name;
  final String nameEn;
  final String category;
  final String specializationId;
  final String location;
  final String coverImagePath;
  final String aboutDescription;
  final List<String> aboutHighlights;
  final String whatsapp;
  final String phone;
  final String commercialRegistrationNumber;
  final String latitude;
  final String longitude;
  final List<ProviderStoreCategoryModel> categories;
  final List<ProviderStoreProductModel> products;

  factory ProviderStoreModel.fromProfileJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final store =
        json['store'] as Map<String, dynamic>? ??
        user['store'] as Map<String, dynamic>? ??
        {};
    final specialization =
        store['specialization'] as Map<String, dynamic>? ?? {};
    return ProviderStoreModel(
      id: store['id']?.toString() ?? '',
      name: store['name']?.toString() ?? '',
      nameEn: store['name']?.toString() ?? '',
      category: specialization['name']?.toString() ?? '',
      specializationId:
          specialization['id']?.toString() ??
          store['specialization_id']?.toString() ??
          '',
      location:
          store['address']?.toString() ??
          user['address']?.toString() ??
          json['address']?.toString() ??
          '',
      coverImagePath: store['logo']?.toString() ?? '',
      aboutDescription: store['description']?.toString() ?? '',
      aboutHighlights: const [],
      whatsapp:
          store['whatsapp']?.toString() ??
          user['phone']?.toString() ??
          json['phone']?.toString() ??
          '',
      phone: user['phone']?.toString() ?? json['phone']?.toString() ?? '',
      commercialRegistrationNumber:
          store['commercial_registration_number']?.toString() ??
          user['commercial_registration_number']?.toString() ??
          '',
      latitude:
          store['latitude']?.toString() ?? user['latitude']?.toString() ?? '',
      longitude:
          store['longitude']?.toString() ?? user['longitude']?.toString() ?? '',
      categories: const [],
      products: const [],
    );
  }

  ProviderStoreModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? category,
    String? specializationId,
    String? location,
    String? coverImagePath,
    String? aboutDescription,
    List<String>? aboutHighlights,
    String? whatsapp,
    String? phone,
    String? commercialRegistrationNumber,
    String? latitude,
    String? longitude,
    List<ProviderStoreCategoryModel>? categories,
    List<ProviderStoreProductModel>? products,
  }) {
    return ProviderStoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      specializationId: specializationId ?? this.specializationId,
      location: location ?? this.location,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      aboutDescription: aboutDescription ?? this.aboutDescription,
      aboutHighlights: aboutHighlights ?? this.aboutHighlights,
      whatsapp: whatsapp ?? this.whatsapp,
      phone: phone ?? this.phone,
      commercialRegistrationNumber:
          commercialRegistrationNumber ?? this.commercialRegistrationNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      categories: categories ?? this.categories,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    nameEn,
    category,
    specializationId,
    location,
    coverImagePath,
    aboutDescription,
    aboutHighlights,
    whatsapp,
    phone,
    commercialRegistrationNumber,
    latitude,
    longitude,
    categories,
    products,
  ];
}

List<ProviderStoreCategoryModel> providerStoreCategoriesFromJson(dynamic json) {
  return List<ProviderStoreCategoryModel>.from(
    (json as List).map(
      (item) =>
          ProviderStoreCategoryModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class ProviderStoreCategoryModel extends Equatable {
  const ProviderStoreCategoryModel({required this.id, required this.name});

  final String id;
  final String name;

  factory ProviderStoreCategoryModel.fromJson(Map<String, dynamic> json) {
    final ar = json['ar'] as Map<String, dynamic>?;
    final en = json['en'] as Map<String, dynamic>?;
    return ProviderStoreCategoryModel(
      id: json['id']?.toString() ?? '',
      name:
          json['name']?.toString() ??
          ar?['name']?.toString() ??
          en?['name']?.toString() ??
          '',
    );
  }

  ProviderStoreCategoryModel copyWith({String? id, String? name}) {
    return ProviderStoreCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}

List<ProviderStoreProductModel> providerStoreProductsFromJson(dynamic json) {
  return List<ProviderStoreProductModel>.from(
    (json as List).map(
      (item) =>
          ProviderStoreProductModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class ProviderStoreProductModel extends Equatable {
  const ProviderStoreProductModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.quantity,
    required this.inStock,
  });

  final String id;
  final String categoryId;
  final String categoryName;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final int quantity;
  final bool inStock;

  factory ProviderStoreProductModel.fromJson(Map<String, dynamic> json) {
    return ProviderStoreProductModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      imagePath:
          json['image']?.toString() ?? json['image_path']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 0,
      inStock: json['in_stock'] == true || json['in_stock'] == 1,
    );
  }

  ProviderStoreProductModel copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    String? name,
    String? description,
    double? price,
    String? imagePath,
    int? quantity,
    bool? inStock,
  }) {
    return ProviderStoreProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
      inStock: inStock ?? this.inStock,
    );
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    categoryName,
    name,
    description,
    price,
    imagePath,
    quantity,
    inStock,
  ];
}
