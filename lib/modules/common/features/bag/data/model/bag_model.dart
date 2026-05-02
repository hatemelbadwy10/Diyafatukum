import 'dart:convert';

import 'package:equatable/equatable.dart';

BagModel bagModelFromJson(dynamic json) =>
    BagModel.fromJson(json as Map<String, dynamic>);

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
    this.subtotalValue,
    this.discountValue,
    this.totalValue,
  });

  final List<BagItemModel> items;
  final double? subtotalValue;
  final double? discountValue;
  final double? totalValue;

  factory BagModel.fromJson(Map<String, dynamic> json) {
    final source = json['cart'] is Map<String, dynamic>
        ? json['cart'] as Map<String, dynamic>
        : json;
    final rawItems =
        source['items'] ??
        source['cart_items'] ??
        source['products'] ??
        const [];
    return BagModel(
      items: (rawItems as List<dynamic>)
          .map((item) => BagItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotalValue: _parseDouble(source['subtotal']),
      discountValue: _parseDouble(source['discount']),
      totalValue: _parseDouble(source['total']),
    );
  }

  double get subtotal =>
      subtotalValue ?? items.fold(0, (total, item) => total + item.totalPrice);

  double get discount => discountValue ?? 0;

  double get total => totalValue ?? (subtotal - discount);

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotalValue,
      'discount': discountValue,
      'total': totalValue,
    };
  }

  BagModel copyWith({
    List<BagItemModel>? items,
    double? subtotalValue,
    double? discountValue,
    double? totalValue,
  }) {
    return BagModel(
      items: items ?? this.items,
      subtotalValue: subtotalValue ?? this.subtotalValue,
      discountValue: discountValue ?? this.discountValue,
      totalValue: totalValue ?? this.totalValue,
    );
  }

  @override
  List<Object?> get props => [items, subtotalValue, discountValue, totalValue];
}

class BagItemModel extends Equatable {
  const BagItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.quantity,
  });

  final String id;
  final String productId;
  final String name;
  final double price;
  final String imagePath;
  final int quantity;

  double get totalPrice => price * quantity;

  factory BagItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>?;
    return BagItemModel(
      id:
          (json['id'] ??
                  json['item_id'] ??
                  json['cart_item_id'] ??
                  json['product_id'] ??
                  '')
              .toString(),
      productId: (json['product_id'] ?? product?['id'] ?? json['id'] ?? '')
          .toString(),
      name: (json['product_name'] ?? json['name'] ?? product?['name'] ?? '')
          .toString(),
      price:
          _parseDouble(
            json['unit_price'] ?? json['price'] ?? product?['price'],
          ) ??
          0,
      imagePath:
          (json['image'] ??
                  json['image_path'] ??
                  product?['image'] ??
                  product?['image_path'] ??
                  '')
              .toString(),
      quantity: _parseInt(json['quantity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'image_path': imagePath,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toCartItemRequest() {
    return {'product_id': _parseInt(productId), 'quantity': quantity};
  }

  BagItemModel copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    String? imagePath,
    int? quantity,
  }) {
    return BagItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, productId, name, price, imagePath, quantity];
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 1;
}
