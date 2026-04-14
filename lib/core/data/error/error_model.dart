import 'package:equatable/equatable.dart';

class ErrorMessageModel extends Equatable {
  final String statusMessage;
  final int? statusCode;
  const ErrorMessageModel({required this.statusMessage, required this.statusCode});

  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    String error = "";
    if (json["errors"] is List) {
      for (var item in (json["errors"] as List)) {
        error = "${error.isEmpty ? "" : "$error \n"} $item";
      }
    } else if (json['error'] is Map && json['error']['message'] != null) {
      error = json['error']['message'].toString();
    } else {
      error = json["message"].toString();
    }

    return ErrorMessageModel(statusMessage: error, statusCode: json["status_code"]);
  }

  @override
  List<Object?> get props => [statusMessage, statusCode];
}
