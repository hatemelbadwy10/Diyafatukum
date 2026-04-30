import 'package:equatable/equatable.dart';

SingleServiceModel singleServiceFromJson(dynamic json) =>
    SingleServiceModel.fromJson(json as Map<String, dynamic>);

class SingleServiceModel extends Equatable {
  const SingleServiceModel({
    required this.titleKey,
    required this.description,
    required this.imageUrl,
    required this.storesCount,
    required this.currentPage,
    required this.lastPage,
    required this.products,
  });

  final String titleKey;
  final String description;
  final String imageUrl;
  final int storesCount;
  final int currentPage;
  final int lastPage;
  final List<SingleServiceProductModel> products;

  factory SingleServiceModel.fromJson(Map<String, dynamic> json) {
    final specialization = json['specialization'] as Map<String, dynamic>? ?? {};
    return SingleServiceModel(
      titleKey: specialization['name'] ?? json['title_key'] ?? '',
      description: specialization['description'] ?? '',
      imageUrl: specialization['image'] ?? '',
      storesCount: specialization['stores_count'] ?? 0,
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      products: singleServiceProductsFromJson(json['stores'] ?? json['products'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
        titleKey,
        description,
        imageUrl,
        storesCount,
        currentPage,
        lastPage,
        products,
      ];
}

List<SingleServiceProductModel> singleServiceProductsFromJson(dynamic json) {
  return List<SingleServiceProductModel>.from(
    (json as List).map(
      (item) =>
          SingleServiceProductModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class SingleServiceProductModel extends Equatable {
  const SingleServiceProductModel({
    required this.id,
    required this.categoryKey,
    required this.name,
    required this.description,
    required this.locationKey,
    required this.imagePath,
    required this.whatsapp,
    required this.ownerName,
    required this.ownerPhone,
  });

  final String id;
  final String categoryKey;
  final String name;
  final String description;
  final String locationKey;
  final String imagePath;
  final String whatsapp;
  final String ownerName;
  final String ownerPhone;

  factory SingleServiceProductModel.fromJson(Map<String, dynamic> json) {
    final specialization = json['specialization'] as Map<String, dynamic>? ?? {};
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    return SingleServiceProductModel(
      id: json['id']?.toString() ?? '',
      categoryKey: specialization['name'] ?? json['category_key'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      locationKey: json['address'] ?? json['location_key'] ?? '',
      imagePath: json['logo'] ?? json['image_path'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      ownerName: owner['name'] ?? '',
      ownerPhone: owner['phone'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        categoryKey,
        name,
        description,
        locationKey,
        imagePath,
        whatsapp,
        ownerName,
        ownerPhone,
      ];
}
