import 'package:equatable/equatable.dart';

import '../../../home/data/model/user_home_model.dart';
import 'single_service_model.dart';

SingleServiceStoreDetailsModel singleServiceStoreDetailsFromJson(dynamic json) =>
    SingleServiceStoreDetailsModel.fromJson(json as Map<String, dynamic>);

class SingleServiceStoreDetailsModel extends Equatable {
  const SingleServiceStoreDetailsModel({
    required this.currentPage,
    required this.lastPage,
    required this.items,
  });

  final int currentPage;
  final int lastPage;
  final List<SingleServiceStoreItemModel> items;

  factory SingleServiceStoreDetailsModel.fromJson(Map<String, dynamic> json) {
    return SingleServiceStoreDetailsModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      items: singleServiceStoreItemsFromJson(json['items'] ?? []),
    );
  }

  @override
  List<Object?> get props => [currentPage, lastPage, items];
}

List<SingleServiceStoreItemModel> singleServiceStoreItemsFromJson(dynamic json) {
  return List<SingleServiceStoreItemModel>.from(
    (json as List).map(
      (item) => SingleServiceStoreItemModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class SingleServiceStoreItemModel extends Equatable {
  const SingleServiceStoreItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  final String id;
  final double price;
  final String name;
  final String imagePath;

  factory SingleServiceStoreItemModel.fromJson(Map<String, dynamic> json) {
    return SingleServiceStoreItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imagePath: json['image_path'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, price, imagePath];
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
