import 'package:equatable/equatable.dart';

import '../../../../../../core/config/extensions/date_time_extensions.dart';
import '../../../../../../core/config/extensions/string_extensions.dart';

List<OrderModel> ordersFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
    final nestedOrders = json['orders'] ?? json['items'] ?? json['data'];
    if (nestedOrders is List) {
      return ordersFromJson(nestedOrders);
    }
  }
  return List<OrderModel>.from(
    (json as List).map(
      (item) => OrderModel.fromJson(item as Map<String, dynamic>),
    ),
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

enum OrderTimelineStatus {
  pending('pending'),
  accepted('accepted'),
  preparing('preparing'),
  onTheWay('on_the_way'),
  delivered('delivered'),
  cancelled('cancelled'),
  rejected('rejected');

  const OrderTimelineStatus(this.value);

  final String value;

  factory OrderTimelineStatus.fromJson(String value) {
    final normalized = value
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
    switch (normalized) {
      case 'accepted':
      case 'received':
        return OrderTimelineStatus.accepted;
      case 'preparing':
      case 'processing':
      case 'process':
        return OrderTimelineStatus.preparing;
      case 'on_the_way':
      case 'transit':
      case 'shipping':
      case 'delivery':
        return OrderTimelineStatus.onTheWay;
      case 'delivered':
      case 'arrived':
      case 'arrive':
      case 'completed':
      case 'complete':
        return OrderTimelineStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderTimelineStatus.cancelled;
      case 'rejected':
      case 'reject':
        return OrderTimelineStatus.rejected;
      default:
        return OrderTimelineStatus.pending;
    }
  }
}

class OrderTimelineStep extends Equatable {
  const OrderTimelineStep({
    required this.status,
    required this.label,
    required this.completed,
    required this.current,
  });

  final OrderTimelineStatus status;
  final String label;
  final bool completed;
  final bool current;

  factory OrderTimelineStep.fromJson(Map<String, dynamic> json) {
    final status = OrderTimelineStatus.fromJson(
      json['status']?.toString() ?? '',
    );
    return OrderTimelineStep(
      status: status,
      label: (json['label'] ?? '').toString(),
      completed: json['completed'] == true,
      current: json['current'] == true,
    );
  }

  OrderTimelineStep copyWith({
    OrderTimelineStatus? status,
    String? label,
    bool? completed,
    bool? current,
  }) {
    return OrderTimelineStep(
      status: status ?? this.status,
      label: label ?? this.label,
      completed: completed ?? this.completed,
      current: current ?? this.current,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.value,
      'label': label,
      'completed': completed,
      'current': current,
    };
  }

  @override
  List<Object?> get props => [status, label, completed, current];
}

class OrderModel extends Equatable {
  const OrderModel({
    required this.backendId,
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
    required this.activeStatus,
    required this.timeline,
    required this.cancellationReason,
    required this.createdAt,
    required this.scheduledAt,
  });

  final String backendId;
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
  final OrderTimelineStatus activeStatus;
  final List<OrderTimelineStep> timeline;
  final String cancellationReason;
  final DateTime? createdAt;
  final DateTime? scheduledAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>?;
    final owner = json['owner'] as Map<String, dynamic>?;
    final items =
        (json['items'] ?? json['products'] ?? json['order_items']) as List?;
    final statusValue =
        (json['tab_status'] ??
                json['status'] ??
                json['order_status'] ??
                json['payment_status'])
            ?.toString() ??
        '';
    final parsedTimeline = _parseTimeline(json['timeline']);
    final activeStatus = _resolveActiveStatus(
      parsedTimeline: parsedTimeline,
      json: json,
      statusValue: statusValue,
    );

    return OrderModel(
      backendId:
          (json['id'] ??
                  json['order_id'] ??
                  json['orderId'] ??
                  json['order_number'] ??
                  '')
              .toString(),
      id: (json['order_number'] ?? json['id'] ?? '').toString(),
      storeName:
          (store?['name'] ??
                  json['store_name'] ??
                  json['provider_name'] ??
                  owner?['name'] ??
                  '')
              .toString(),
      storeImagePath:
          (store?['image'] ??
                  store?['logo'] ??
                  json['store_image_path'] ??
                  json['store_image'] ??
                  '')
              .toString(),
      storePhone:
          (store?['phone'] ??
                  json['store_phone'] ??
                  owner?['phone'] ??
                  json['phone'] ??
                  '')
              .toString(),
      itemsSummary: _parseItemsSummary(
        rawItemsSummary: json['items_summary'],
        items: items,
      ),
      dateLabel: _parseOrderDateLabel(
        json['date_label'] ??
            json['occasion_date'] ??
            json['delivery_date'] ??
            json['created_at'],
      ),
      address: (json['delivery_address'] ?? json['address'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      totalPaid: _parseDouble(
        json['total_paid'] ??
            json['total'] ??
            json['grand_total'] ??
            json['amount'],
      ),
      tabStatus: _resolveTabStatus(statusValue),
      activeStatus: activeStatus,
      timeline: _normalizeTimeline(parsedTimeline, activeStatus),
      cancellationReason:
          (json['cancellation_reason'] ??
                  json['cancel_reason'] ??
                  json['cancelled_reason'] ??
                  '')
              .toString(),
      createdAt: _parseNullableDateTime(
        json['created_at'] ?? json['createdAt'],
      ),
      scheduledAt: _parseNullableDateTime(
        json['occasion_date'] ??
            json['delivery_date'] ??
            json['scheduled_at'] ??
            json['event_date'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backend_id': backendId,
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
      'active_status': activeStatus.value,
      'timeline': timeline.map((step) => step.toJson()).toList(),
      'cancellation_reason': cancellationReason,
      'created_at': createdAt?.toIso8601String(),
      'scheduled_at': scheduledAt?.toIso8601String(),
    };
  }

  bool get hasExecutionStarted =>
      activeStatus == OrderTimelineStatus.preparing ||
      activeStatus == OrderTimelineStatus.onTheWay ||
      activeStatus == OrderTimelineStatus.delivered;

  bool get canRequestCancellation =>
      tabStatus == OrderTabStatus.current &&
      activeStatus != OrderTimelineStatus.cancelled &&
      activeStatus != OrderTimelineStatus.rejected &&
      !hasExecutionStarted;

  bool get canProviderAccept =>
      tabStatus == OrderTabStatus.current &&
      activeStatus == OrderTimelineStatus.pending;

  bool get canProviderReject =>
      tabStatus == OrderTabStatus.current &&
      activeStatus == OrderTimelineStatus.pending;

  OrderTimelineStatus? get nextProviderStatus {
    switch (activeStatus) {
      case OrderTimelineStatus.accepted:
        return OrderTimelineStatus.preparing;
      case OrderTimelineStatus.preparing:
        return OrderTimelineStatus.onTheWay;
      case OrderTimelineStatus.onTheWay:
        return OrderTimelineStatus.delivered;
      default:
        return null;
    }
  }

  bool get canProviderAdvanceStatus =>
      tabStatus == OrderTabStatus.current && nextProviderStatus != null;

  OrderCancellationPolicy get cancellationPolicy {
    if (scheduledAt == null) return OrderCancellationPolicy.review;

    final now = DateTime.now();
    final durationUntilEvent = scheduledAt!.difference(now);

    if (durationUntilEvent.inHours < 48) {
      return OrderCancellationPolicy.none;
    }

    if (durationUntilEvent.inHours < 72) {
      return OrderCancellationPolicy.quarter;
    }

    final hasRecentConfirmation =
        createdAt != null &&
        now.difference(createdAt!).inHours <= 24 &&
        durationUntilEvent.inHours > 72;

    if (hasRecentConfirmation || durationUntilEvent.inHours >= 168) {
      return OrderCancellationPolicy.full;
    }

    if (durationUntilEvent.inHours >= 72) {
      return OrderCancellationPolicy.half;
    }

    return OrderCancellationPolicy.review;
  }

  OrderModel copyWith({
    String? backendId,
    String? id,
    String? storeName,
    String? storeImagePath,
    String? storePhone,
    List<String>? itemsSummary,
    String? dateLabel,
    String? address,
    String? notes,
    double? totalPaid,
    OrderTabStatus? tabStatus,
    OrderTimelineStatus? activeStatus,
    List<OrderTimelineStep>? timeline,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? scheduledAt,
  }) {
    return OrderModel(
      backendId: backendId ?? this.backendId,
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      storeImagePath: storeImagePath ?? this.storeImagePath,
      storePhone: storePhone ?? this.storePhone,
      itemsSummary: itemsSummary ?? this.itemsSummary,
      dateLabel: dateLabel ?? this.dateLabel,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      totalPaid: totalPaid ?? this.totalPaid,
      tabStatus: tabStatus ?? this.tabStatus,
      activeStatus: activeStatus ?? this.activeStatus,
      timeline: timeline ?? this.timeline,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }

  @override
  List<Object?> get props => [
    backendId,
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
    activeStatus,
    timeline,
    cancellationReason,
    createdAt,
    scheduledAt,
  ];

  OrderModel markProviderAccepted() {
    return copyWith(
      tabStatus: OrderTabStatus.current,
      activeStatus: OrderTimelineStatus.accepted,
      timeline: _normalizeTimeline(
        const [],
        OrderTimelineStatus.accepted,
      ),
    );
  }

  OrderModel markProviderRejected(String reason) {
    return copyWith(
      tabStatus: OrderTabStatus.cancelled,
      activeStatus: OrderTimelineStatus.rejected,
      cancellationReason: reason,
      timeline: const [
        OrderTimelineStep(
          status: OrderTimelineStatus.rejected,
          label: '',
          completed: true,
          current: true,
        ),
      ],
    );
  }

  OrderModel markProviderAdvanced(OrderTimelineStatus status) {
    return copyWith(
      tabStatus: status == OrderTimelineStatus.delivered
          ? OrderTabStatus.completed
          : OrderTabStatus.current,
      activeStatus: status,
      timeline: _normalizeTimeline(const [], status),
    );
  }
}

enum OrderCancellationPolicy { full, half, quarter, none, review }

List<String> _parseItemsSummary({dynamic rawItemsSummary, List? items}) {
  if (rawItemsSummary is List) {
    return rawItemsSummary.map((item) => item.toString()).toList();
  }

  if (items == null) return const [];

  return items
      .map((item) {
        if (item is! Map<String, dynamic>) return item.toString();
        final quantity = item['quantity'];
        final name =
            item['name'] ??
            item['product_name'] ??
            item['title'] ??
            item['category_name'] ??
            '';
        if (quantity != null) {
          return '${quantity}x $name';
        }
        return name.toString();
      })
      .where((item) => item.trim().isNotEmpty)
      .toList();
}

double _parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _parseNullableDateTime(dynamic value) {
  final rawValue = value?.toString();
  if (rawValue == null || rawValue.isEmpty || rawValue == 'null') {
    return null;
  }

  return DateTime.tryParse(rawValue);
}

String _parseOrderDateLabel(dynamic value) {
  final rawValue = value?.toString() ?? '';
  if (rawValue.isEmpty) return '';

  try {
    return rawValue.toDateTime().format(format: 'EEEE، d MMMM yyyy');
  } catch (_) {
    return rawValue;
  }
}

OrderTabStatus _resolveTabStatus(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('complete') || normalized.contains('deliver')) {
    return OrderTabStatus.completed;
  }
  if (normalized.contains('cancel') || normalized.contains('reject')) {
    return OrderTabStatus.cancelled;
  }
  return OrderTabStatus.current;
}

List<OrderTimelineStep> _parseTimeline(dynamic value) {
  if (value is! List) return const [];

  return value
      .whereType<Map>()
      .map(
        (item) => OrderTimelineStep.fromJson(Map<String, dynamic>.from(item)),
      )
      .toList();
}

OrderTimelineStatus _resolveActiveStatus({
  required List<OrderTimelineStep> parsedTimeline,
  required Map<String, dynamic> json,
  required String statusValue,
}) {
  for (final step in parsedTimeline) {
    if (step.current) return step.status;
  }

  final activeValue =
      (json['active_status'] ??
              json['active_stage'] ??
              json['tracking_status'] ??
              statusValue)
          .toString();
  return OrderTimelineStatus.fromJson(activeValue);
}

List<OrderTimelineStep> _normalizeTimeline(
  List<OrderTimelineStep> timeline,
  OrderTimelineStatus activeStatus,
) {
  if (timeline.isEmpty) return _fallbackTimeline(activeStatus);

  final stepsByStatus = {for (final step in timeline) step.status: step};
  final isTerminalStatus =
      activeStatus == OrderTimelineStatus.delivered ||
      activeStatus == OrderTimelineStatus.cancelled ||
      activeStatus == OrderTimelineStatus.rejected;
  final activeIndex = _progressStatuses.indexOf(
    activeStatus == OrderTimelineStatus.cancelled ||
            activeStatus == OrderTimelineStatus.rejected
        ? OrderTimelineStatus.delivered
        : activeStatus,
  );

  return _progressStatuses.map((status) {
    final baseStep =
        stepsByStatus[status] ??
        OrderTimelineStep(
          status: status,
          label: '',
          completed: false,
          current: false,
        );
    final index = _progressStatuses.indexOf(status);

    if (isTerminalStatus) {
      return baseStep.copyWith(completed: true, current: false);
    }

    return baseStep.copyWith(
      completed: index <= activeIndex,
      current: status == activeStatus,
    );
  }).toList();
}

List<OrderTimelineStep> _fallbackTimeline(OrderTimelineStatus activeStatus) {
  final isTerminalStatus =
      activeStatus == OrderTimelineStatus.delivered ||
      activeStatus == OrderTimelineStatus.cancelled ||
      activeStatus == OrderTimelineStatus.rejected;
  final activeIndex = _progressStatuses.indexOf(
    activeStatus == OrderTimelineStatus.cancelled ||
            activeStatus == OrderTimelineStatus.rejected
        ? OrderTimelineStatus.delivered
        : activeStatus,
  );

  return _progressStatuses.map((status) {
    final index = _progressStatuses.indexOf(status);
    return OrderTimelineStep(
      status: status,
      label: '',
      completed: isTerminalStatus || (activeIndex >= 0 && index <= activeIndex),
      current:
          !isTerminalStatus &&
          activeStatus != OrderTimelineStatus.cancelled &&
          activeStatus != OrderTimelineStatus.rejected &&
          status == activeStatus,
    );
  }).toList();
}

const List<OrderTimelineStatus> _progressStatuses = [
  OrderTimelineStatus.pending,
  OrderTimelineStatus.accepted,
  OrderTimelineStatus.preparing,
  OrderTimelineStatus.onTheWay,
  OrderTimelineStatus.delivered,
];
