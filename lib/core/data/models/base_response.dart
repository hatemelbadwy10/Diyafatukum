import 'package:dartz/dartz.dart';

import '../../resources/type_defs.dart';

BaseResponse<T> parseBaseResponse<T>(dynamic json, FromJson<T> fromJsonT) {
  return BaseResponse<T>.fromJson(json, fromJsonT);
}

Unit noDataFromJson(_) => unit;

class BaseResponse<T> {
  const BaseResponse({this.success, this.message, this.data});

  final bool? success;
  final String? message;
  final T? data;

  factory BaseResponse.fromJson(Map<String, dynamic> json, FromJson<T> fromJsonT) {
    return BaseResponse<T>(
      success: json['success'] ?? json['status'] ?? true,
      data: _parseData(json, fromJsonT),
      message: json['message'] ?? '',
    );
  }

  static T? _parseData<T>(Map<String, dynamic> json, FromJson<T> fromJsonT) {
    if (json['data'] != null) {
      return fromJsonT(json['data']);
    }

    if (json['payload'] != null) {
      return fromJsonT(json['payload']);
    }

    return null;
  }
}
