import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.type,
    required this.isRead,
    this.readAt,
  });

  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  final String type;
  final bool isRead;
  final DateTime? readAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final title = (json['title'] ?? data?['title'] ?? json['subject'] ?? '')
        .toString();
    final message =
        (json['message'] ??
                json['body'] ??
                data?['message'] ??
                data?['body'] ??
                '')
            .toString();

    return NotificationModel(
      id: (json['id'] ?? data?['id'] ?? title).toString(),
      title: title,
      message: message,
      createdAt: _parseDateTime(
        json['created_at'] ?? json['sent_at'] ?? json['date'],
      ),
      type:
          (json['type'] ??
                  json['notification_type'] ??
                  json['kind'] ??
                  data?['type'] ??
                  '')
              .toString(),
      isRead:
          json['is_read'] == true ||
          json['read'] == true ||
          json['read_at'] != null,
      readAt: json['read_at'] == null ? null : _parseDateTime(json['read_at']),
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? createdAt,
    String? type,
    bool? isRead,
    DateTime? readAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }

  bool get isOffer {
    final normalized = '${title.toLowerCase()} ${type.toLowerCase()}';
    return normalized.contains('offer') ||
        normalized.contains('discount') ||
        normalized.contains('promo') ||
        normalized.contains('خصم') ||
        normalized.contains('عرض');
  }

  bool get isReminder {
    final normalized = '${title.toLowerCase()} ${type.toLowerCase()}';
    return normalized.contains('reminder') ||
        normalized.contains('order') ||
        normalized.contains('تذكير');
  }

  @override
  List<Object?> get props => [
    id,
    title,
    message,
    createdAt,
    type,
    isRead,
    readAt,
  ];
}

List<NotificationModel> notificationsFromJson(dynamic json) {
  final payload = json is Map<String, dynamic>
      ? (json['payload'] as Map<String, dynamic>?) ?? json
      : <String, dynamic>{};
  final rawNotifications =
      payload['notifications'] ??
      payload['items'] ??
      payload['data'] ??
      const [];

  if (rawNotifications is! List) return const [];

  return rawNotifications
      .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
      .toList();
}

DateTime _parseDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString()) ?? DateTime.now();
}
