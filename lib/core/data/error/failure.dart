import 'package:equatable/equatable.dart';

import 'error_constants.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;
  final String? details;

  const Failure({required this.message, this.statusCode = ResponseCode.DEFAULT, this.details});

  @override
  List<Object?> get props => [message, statusCode, details];
}

// Network/Remote Failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode, super.details});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.details})
    : super(statusCode: ResponseCode.NO_INTERNET_CONNECTION);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message, super.details}) : super(statusCode: ResponseCode.CONNECT_TIMEOUT);
}

// Authentication Failures
class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({required super.message, super.details}) : super(statusCode: ResponseCode.UNAUTHORIZED);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message, super.details}) : super(statusCode: ResponseCode.FORBIDDEN);
}

class UserNotAllowedFailure extends Failure {
  const UserNotAllowedFailure({required super.message, super.details}) : super(statusCode: ResponseCode.NOT_ALLOWED);
}

class UserBlockedFailure extends Failure {
  const UserBlockedFailure({required super.message, super.details}) : super(statusCode: ResponseCode.BLOCKED);
}

// Local/Device Failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.details}) : super(statusCode: ResponseCode.CACHE_ERROR);
}

class LocationFailure extends Failure {
  const LocationFailure({required super.message, super.details}) : super(statusCode: ResponseCode.LOCATION_ERROR);
}

class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, super.details}) : super(statusCode: ResponseCode.PERMISSION_DENIED);
}

class FileFailure extends Failure {
  const FileFailure({required super.message, super.details}) : super(statusCode: ResponseCode.FILE_ERROR);
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.details}) : super(statusCode: ResponseCode.VALIDATION_ERROR);
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.details}) : super(statusCode: ResponseCode.CACHE_ERROR);
}

class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.details}) : super(statusCode: ResponseCode.DEFAULT);
}
