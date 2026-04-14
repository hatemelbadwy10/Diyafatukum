// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'package:easy_localization/easy_localization.dart';

import '../../resources/resources.dart';
import 'failure.dart';

class ErrorConstants {
  ErrorConstants._();

  // Network/Server errors
  static String success = LocaleKeys.error_dio_success;
  static String badRequestError = LocaleKeys.error_dio_bad_request;
  static String noContent = LocaleKeys.error_dio_no_content;
  static String forbiddenError = LocaleKeys.error_dio_forbidden;
  static String unauthorizedError = LocaleKeys.error_dio_unauthorized;
  static String notFoundError = LocaleKeys.error_dio_not_found;
  static String internalServerError = LocaleKeys.error_dio_internal_server_error;
  static String connectTimeoutError = LocaleKeys.error_dio_connect_timeout;
  static String sendTimeoutError = LocaleKeys.error_dio_send_timeout;
  static String receiveTimeoutError = LocaleKeys.error_dio_receive_timeout;

  // General errors
  static String unknownError = LocaleKeys.error_dio_default;
  static String cacheError = LocaleKeys.error_dio_cache_error;
  static String noInternetError = LocaleKeys.error_dio_no_internet_connection;
  static String defaultError = LocaleKeys.error_dio_default;

  // Custom business logic errors
  static String blockedError = LocaleKeys.error_dio_blocked;
  static String notAllowed = LocaleKeys.error_dio_not_allowed;

  // Local/Device errors
  static String locationError = LocaleKeys.error_location_message;
  static String permissionDenied = LocaleKeys.error_location_permission_denied;
  static String fileError = LocaleKeys.error_open_file_message;
  static String downloadError = LocaleKeys.error_download_message;
  static String invalidError = LocaleKeys.error_invalid_message;
}

// Response status codes (keep existing)
class ResponseCode {
  static const int SUCCESS = 200;
  static const int CREATED = 201;
  static const int NO_CONTENT = 204;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int NOT_ALLOWED = 405;
  static const int BLOCKED = 420;
  static const int Bad_Content = 422;
  static const int BAD_REQUEST_Server = 402;
  static const int INTERNAL_SERVER_ERROR = 500;

  // Local status codes
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECEIVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
  static const int LOCATION_ERROR = -8;
  static const int PERMISSION_DENIED = -9;
  static const int FILE_ERROR = -10;
  static const int VALIDATION_ERROR = -11;
}

// Enhanced Status Type
enum ErrorType {
  // Network errors
  network,
  timeout,
  server,

  // Authentication errors
  unauthorized,
  forbidden,
  blocked,

  // Local errors
  cache,
  database,
  location,
  permission,
  file,
  validation,

  // Generic
  unknown,
}

extension ErrorTypeExtension on ErrorType {
  Failure getFailure({String? customMessage, String? details}) {
    switch (this) {
      case ErrorType.network:
        return NetworkFailure(message: customMessage ?? ErrorConstants.noInternetError.tr(), details: details);
      case ErrorType.timeout:
        return TimeoutFailure(message: customMessage ?? ErrorConstants.connectTimeoutError.tr(), details: details);
      case ErrorType.server:
        return ServerFailure(message: customMessage ?? ErrorConstants.internalServerError.tr(), details: details);
      case ErrorType.unauthorized:
        return UnauthenticatedFailure(
          message: customMessage ?? ErrorConstants.unauthorizedError.tr(),
          details: details,
        );
      case ErrorType.forbidden:
        return UnauthorizedFailure(message: customMessage ?? ErrorConstants.forbiddenError.tr(), details: details);
      case ErrorType.blocked:
        return UserBlockedFailure(message: customMessage ?? ErrorConstants.blockedError.tr(), details: details);
      case ErrorType.cache:
        return CacheFailure(message: customMessage ?? ErrorConstants.cacheError.tr(), details: details);
      case ErrorType.database:
        return DatabaseFailure(message: customMessage ?? ErrorConstants.defaultError.tr(), details: details);
      case ErrorType.location:
        return LocationFailure(message: customMessage ?? ErrorConstants.locationError.tr(), details: details);
      case ErrorType.permission:
        return PermissionFailure(message: customMessage ?? ErrorConstants.permissionDenied.tr(), details: details);
      case ErrorType.file:
        return FileFailure(message: customMessage ?? ErrorConstants.fileError.tr(), details: details);
      case ErrorType.validation:
        return ValidationFailure(message: customMessage ?? ErrorConstants.invalidError.tr(), details: details);
      case ErrorType.unknown:
        return UnknownFailure(message: customMessage ?? ErrorConstants.unknownError.tr(), details: details);
    }
  }
}
