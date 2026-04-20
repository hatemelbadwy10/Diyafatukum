import 'package:equatable/equatable.dart';

SingleServiceModel singleServiceFromJson(dynamic json) =>
    SingleServiceModel.fromJson(json as Map<String, dynamic>);

class SingleServiceModel extends Equatable {
  const SingleServiceModel({
    required this.titleKey,
    required this.currentPage,
    required this.lastPage,
    required this.products,
  });

  final String titleKey;
  final int currentPage;
  final int lastPage;
  final List<SingleServiceProductModel> products;

  factory SingleServiceModel.fromJson(Map<String, dynamic> json) {
    return SingleServiceModel(
      titleKey: json['title_key'] ?? '',
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      products: singleServiceProductsFromJson(json['products'] ?? []),
    );
  }

  @override
  List<Object?> get props => [titleKey, currentPage, lastPage, products];
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
    required this.locationKey,
    required this.imagePath,
  });

  final String id;
  final String categoryKey;
  final String name;
  final String locationKey;
  final String imagePath;

  factory SingleServiceProductModel.fromJson(Map<String, dynamic> json) {
    return SingleServiceProductModel(
      id: json['id'] ?? '',
      categoryKey: json['category_key'] ?? '',
      name: json['name'] ?? '',
      locationKey: json['location_key'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, categoryKey, name, locationKey, imagePath];
}
