import 'package:equatable/equatable.dart';

enum PushNotificationType {
  newOrder,
  orderStatusUpdated,
  unknown;

  factory PushNotificationType.fromJson(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'new_order':
        return PushNotificationType.newOrder;
      case 'order_status_updated':
        return PushNotificationType.orderStatusUpdated;
      default:
        return PushNotificationType.unknown;
    }
  }
}

class PushNotificationModel extends Equatable {
  const PushNotificationModel({required this.type, required this.orderId});

  final PushNotificationType type;
  final String orderId;

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationModel(
      type: PushNotificationType.fromJson(json['type']?.toString()),
      orderId: (json['id'] ?? '').toString(),
    );
  }

  bool get targetsOrder =>
      type != PushNotificationType.unknown && orderId.isNotEmpty;

  @override
  List<Object> get props => [type, orderId];
}
