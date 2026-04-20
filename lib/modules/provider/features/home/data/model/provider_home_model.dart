import 'package:equatable/equatable.dart';

List<ProviderHomeOrderModel> providerHomeOrdersFromJson(dynamic json) {
  return List<ProviderHomeOrderModel>.from(
    (json as List).map(
      (item) => ProviderHomeOrderModel.fromJson(item as Map<String, dynamic>),
    ),
  );
}

class ProviderHomeModel extends Equatable {
  const ProviderHomeModel({
    required this.providerName,
    required this.orders,
  });

  final String providerName;
  final List<ProviderHomeOrderModel> orders;

  factory ProviderHomeModel.fromJson(Map<String, dynamic> json) {
    return ProviderHomeModel(
      providerName: json['provider_name'] ?? '',
      orders: providerHomeOrdersFromJson(json['orders'] ?? const []),
    );
  }

  ProviderHomeModel copyWith({
    String? providerName,
    List<ProviderHomeOrderModel>? orders,
  }) {
    return ProviderHomeModel(
      providerName: providerName ?? this.providerName,
      orders: orders ?? this.orders,
    );
  }

  @override
  List<Object?> get props => [providerName, orders];
}

enum ProviderHomeOrderStatus {
  pending,
  accepted,
  rejected;

  factory ProviderHomeOrderStatus.fromJson(String value) {
    switch (value) {
      case 'accepted':
        return ProviderHomeOrderStatus.accepted;
      case 'rejected':
        return ProviderHomeOrderStatus.rejected;
      default:
        return ProviderHomeOrderStatus.pending;
    }
  }
}

class ProviderHomeOrderModel extends Equatable {
  const ProviderHomeOrderModel({
    required this.id,
    required this.customerName,
    required this.dateLabel,
    required this.status,
  });

  final String id;
  final String customerName;
  final String dateLabel;
  final ProviderHomeOrderStatus status;

  factory ProviderHomeOrderModel.fromJson(Map<String, dynamic> json) {
    return ProviderHomeOrderModel(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      dateLabel: json['date_label'] ?? '',
      status: ProviderHomeOrderStatus.fromJson(json['status'] ?? ''),
    );
  }

  ProviderHomeOrderModel copyWith({
    String? id,
    String? customerName,
    String? dateLabel,
    ProviderHomeOrderStatus? status,
  }) {
    return ProviderHomeOrderModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      dateLabel: dateLabel ?? this.dateLabel,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, customerName, dateLabel, status];
}
