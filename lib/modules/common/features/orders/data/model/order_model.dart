import 'package:equatable/equatable.dart';

List<OrderModel> ordersFromJson(dynamic json) {
  return List<OrderModel>.from(
    (json as List).map((item) => OrderModel.fromJson(item as Map<String, dynamic>)),
  );
}

enum OrderTabStatus {
  current,
  completed,
  cancelled;

  factory OrderTabStatus.fromJson(String value) {
    switch (value) {
      case 'completed':
        return OrderTabStatus.completed;
      case 'cancelled':
        return OrderTabStatus.cancelled;
      default:
        return OrderTabStatus.current;
    }
  }
}

enum OrderProgressStage {
  received,
  processing,
  transit,
  delivered;
}

class OrderModel extends Equatable {
  const OrderModel({
    required this.id,
    required this.storeName,
    required this.storeImagePath,
    required this.storePhone,
    required this.itemsSummary,
    required this.dateLabel,
    required this.address,
    required this.notes,
    required this.totalPaid,
    required this.tabStatus,
    required this.activeStage,
  });

  final String id;
  final String storeName;
  final String storeImagePath;
  final String storePhone;
  final List<String> itemsSummary;
  final String dateLabel;
  final String address;
  final String notes;
  final double totalPaid;
  final OrderTabStatus tabStatus;
  final OrderProgressStage activeStage;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      storeName: json['store_name'] ?? '',
      storeImagePath: json['store_image_path'] ?? '',
      storePhone: json['store_phone'] ?? '',
      itemsSummary: List<String>.from(json['items_summary'] ?? const []),
      dateLabel: json['date_label'] ?? '',
      address: json['address'] ?? '',
      notes: json['notes'] ?? '',
      totalPaid: (json['total_paid'] ?? 0).toDouble(),
      tabStatus: OrderTabStatus.fromJson(json['tab_status'] ?? ''),
      activeStage: OrderProgressStage.values.firstWhere(
        (value) => value.name == json['active_stage'],
        orElse: () => OrderProgressStage.received,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'store_image_path': storeImagePath,
      'store_phone': storePhone,
      'items_summary': itemsSummary,
      'date_label': dateLabel,
      'address': address,
      'notes': notes,
      'total_paid': totalPaid,
      'tab_status': tabStatus.name,
      'active_stage': activeStage.name,
    };
  }

  @override
  List<Object?> get props => [
        id,
        storeName,
        storeImagePath,
        storePhone,
        itemsSummary,
        dateLabel,
        address,
        notes,
        totalPaid,
        tabStatus,
        activeStage,
      ];
}
