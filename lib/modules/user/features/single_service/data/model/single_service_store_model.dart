import 'package:equatable/equatable.dart';

import '../../../home/data/model/user_home_model.dart';
import 'single_service_model.dart';

SingleServiceStoreDetailsModel singleServiceStoreDetailsFromJson(
  dynamic json,
) => SingleServiceStoreDetailsModel.fromJson(json as Map<String, dynamic>);

class SingleServiceStoreDetailsModel extends Equatable {
  const SingleServiceStoreDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.whatsapp,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.logo,
    required this.specializationName,
    required this.ownerName,
    required this.ownerPhone,
    required this.categoriesCount,
    required this.productsCount,
    required this.categories,
    required this.items,
  });

  final String id;
  final String name;
  final String description;
  final String whatsapp;
  final String address;
  final String latitude;
  final String longitude;
  final String logo;
  final String specializationName;
  final String ownerName;
  final String ownerPhone;
  final int categoriesCount;
  final int productsCount;
  final List<SingleServiceStoreCategoryModel> categories;
  final List<SingleServiceStoreItemModel> items;

  factory SingleServiceStoreDetailsModel.fromJson(Map<String, dynamic> json) {
    final specialization =
        json['specialization'] as Map<String, dynamic>? ?? {};
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    return SingleServiceStoreDetailsModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      logo: json['logo'] ?? '',
      specializationName: specialization['name'] ?? '',
      ownerName: owner['name'] ?? '',
      ownerPhone: owner['phone'] ?? '',
      categoriesCount: json['categories_count'] ?? 0,
      productsCount: json['products_count'] ?? 0,
      categories: singleServiceStoreCategoriesFromJson(
        json['categories'] ?? [],
      ),
      items: singleServiceStoreItemsFromJson(json['products'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    whatsapp,
    address,
    latitude,
    longitude,
    logo,
    specializationName,
    ownerName,
    ownerPhone,
    categoriesCount,
    productsCount,
    categories,
    items,
  ];
}

List<SingleServiceStoreCategoryModel> singleServiceStoreCategoriesFromJson(
  dynamic json,
) {
  return List<SingleServiceStoreCategoryModel>.from(
    (json as List).map(
      (item) => SingleServiceStoreCategoryModel.fromJson(
        item as Map<String, dynamic>,
      ),
    ),
  );
}

class SingleServiceStoreCategoryModel extends Equatable {
  const SingleServiceStoreCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.productsCount,
  });

  final String id;
  final String name;
  final String description;
  final int productsCount;

  factory SingleServiceStoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return SingleServiceStoreCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      productsCount: json['products_count'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, description, productsCount];
}

List<SingleServiceStoreItemModel> singleServiceStoreItemsFromJson(
  dynamic json,
) {
  return List<SingleServiceStoreItemModel>.from(
    (json as List).map(
      (item) =>
          SingleServiceStoreItemModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class SingleServiceStoreItemModel extends Equatable {
  const SingleServiceStoreItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.categoryId,
    required this.categoryName,
    required this.quantity,
    required this.inStock,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;
  final String categoryId;
  final String categoryName;
  final int quantity;
  final bool inStock;

  bool get isAvailable => inStock && quantity > 0;

  factory SingleServiceStoreItemModel.fromJson(Map<String, dynamic> json) {
    return SingleServiceStoreItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      imagePath: json['image'] ?? json['image_path'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      inStock: json['in_stock'] == true || json['in_stock'] == 1,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imagePath,
    categoryId,
    categoryName,
    quantity,
    inStock,
  ];
}

class SingleServiceStoreScreenArguments extends Equatable {
  const SingleServiceStoreScreenArguments({
    required this.service,
    required this.store,
  });

  final UserHomeServiceModel service;
  final SingleServiceProductModel store;

  @override
  List<Object?> get props => [service, store];
}
