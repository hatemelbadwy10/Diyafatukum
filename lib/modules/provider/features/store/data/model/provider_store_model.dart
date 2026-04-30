import 'package:equatable/equatable.dart';

ProviderStoreModel providerStoreFromJson(dynamic json) =>
    ProviderStoreModel.fromJson(json as Map<String, dynamic>);

class ProviderStoreModel extends Equatable {
  const ProviderStoreModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.category,
    required this.location,
    required this.coverImagePath,
    required this.aboutDescription,
    required this.aboutHighlights,
    required this.whatsapp,
    required this.categories,
    required this.products,
  });

  final String id;
  final String name;
  final String nameEn;
  final String category;
  final String location;
  final String coverImagePath;
  final String aboutDescription;
  final List<String> aboutHighlights;
  final String whatsapp;
  final List<ProviderStoreCategoryModel> categories;
  final List<ProviderStoreProductModel> products;

  factory ProviderStoreModel.fromJson(Map<String, dynamic> json) {
    return ProviderStoreModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? json['name'] ?? '',
      category: json['category'] ?? '',
      location: json['location'] ?? '',
      coverImagePath: json['cover_image_path'] ?? '',
      aboutDescription: json['about_description'] ?? '',
      aboutHighlights: List<String>.from(json['about_highlights'] ?? const []),
      whatsapp: json['whatsapp'] ?? '',
      categories: providerStoreCategoriesFromJson(json['categories'] ?? const []),
      products: providerStoreProductsFromJson(json['products'] ?? const []),
    );
  }

  ProviderStoreModel copyWith({
    String? id,
    String? name,
    String? nameEn,
    String? category,
    String? location,
    String? coverImagePath,
    String? aboutDescription,
    List<String>? aboutHighlights,
    String? whatsapp,
    List<ProviderStoreCategoryModel>? categories,
    List<ProviderStoreProductModel>? products,
  }) {
    return ProviderStoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      category: category ?? this.category,
      location: location ?? this.location,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      aboutDescription: aboutDescription ?? this.aboutDescription,
      aboutHighlights: aboutHighlights ?? this.aboutHighlights,
      whatsapp: whatsapp ?? this.whatsapp,
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
    location,
    coverImagePath,
    aboutDescription,
    aboutHighlights,
    whatsapp,
    categories,
    products,
  ];
}

List<ProviderStoreCategoryModel> providerStoreCategoriesFromJson(dynamic json) {
  return List<ProviderStoreCategoryModel>.from(
    (json as List).map(
      (item) => ProviderStoreCategoryModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class ProviderStoreCategoryModel extends Equatable {
  const ProviderStoreCategoryModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory ProviderStoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProviderStoreCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}

List<ProviderStoreProductModel> providerStoreProductsFromJson(dynamic json) {
  return List<ProviderStoreProductModel>.from(
    (json as List).map(
      (item) => ProviderStoreProductModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class ProviderStoreProductModel extends Equatable {
  const ProviderStoreProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  final String id;
  final String categoryId;
  final String name;
  final double price;
  final String imagePath;

  factory ProviderStoreProductModel.fromJson(Map<String, dynamic> json) {
    return ProviderStoreProductModel(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imagePath: json['image_path'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, categoryId, name, price, imagePath];
}
