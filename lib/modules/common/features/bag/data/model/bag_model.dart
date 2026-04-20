import 'dart:convert';

import 'package:equatable/equatable.dart';

BagModel bagModelFromJson(dynamic json) => BagModel.fromJson(json as Map<String, dynamic>);

String bagItemsToJson(List<BagItemModel> items) =>
    jsonEncode(items.map((item) => item.toJson()).toList());

List<BagItemModel> bagItemsFromStorage(String? raw) {
  if (raw == null || raw.isEmpty) return const [];

  final decoded = jsonDecode(raw);
  if (decoded is! List) return const [];

  return decoded
      .map((item) => BagItemModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

class BagModel extends Equatable {
  const BagModel({
    required this.items,
  });

  final List<BagItemModel> items;

  factory BagModel.fromJson(Map<String, dynamic> json) {
    return BagModel(
      items: (json['items'] as List<dynamic>? ?? const [])
          .map((item) => BagItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  double get subtotal => items.fold(0, (total, item) => total + item.totalPrice);

  double get discount => items.length > 1 ? 50 : 0;

  double get total => subtotal - discount;

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [items];
}

class BagItemModel extends Equatable {
  const BagItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.quantity,
  });

  final String id;
  final String name;
  final double price;
  final String imagePath;
  final int quantity;

  double get totalPrice => price * quantity;

  factory BagItemModel.fromJson(Map<String, dynamic> json) {
    return BagItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imagePath: json['image_path'] ?? '',
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_path': imagePath,
      'quantity': quantity,
    };
  }

  BagItemModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imagePath,
    int? quantity,
  }) {
    return BagItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, name, price, imagePath, quantity];
}
