import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../config/router/app_route.dart';
import '../../config/router/route_manager.dart';
import '../../resources/type_defs.dart';
import '../../utils/toaster_utils.dart';
import '../models/base_response.dart';
import 'error_constants.dart';
import 'error_model.dart';
import 'failure.dart';

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    failure = _mapErrorToFailure(error);
    _logError(error);
  }

  Failure _mapErrorToFailure(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return NetworkFailure(message: ErrorConstants.noInternetError.tr(), details: error.message);
    } else if (error is HttpException) {
      return ServerFailure(message: ErrorConstants.internalServerError.tr(), details: error.message);
    } else if (error is FormatException) {
      return ValidationFailure(message: ErrorConstants.badRequestError.tr(), details: error.message);
    } else if (error is FileSystemException) {
      return FileFailure(message: ErrorConstants.defaultError.tr(), details: error.message);
    } else if (error is TypeError) {
      return ValidationFailure(message: ErrorConstants.badRequestError.tr(), details: error.toString());
    } else {
      return UnknownFailure(message: ErrorConstants.unknownError.tr(), details: error.toString());
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(message: _getTimeoutMessage(error.type).tr(), details: error.message);

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return ServerFailure(
          message: ErrorConstants.defaultError.tr(),
          statusCode: ResponseCode.CANCEL,
          details: 'Request was cancelled',
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(message: ErrorConstants.noInternetError.tr(), details: error.message);

      case DioExceptionType.badCertificate:
        return ServerFailure(message: ErrorConstants.badRequestError.tr(), details: 'Bad certificate');

      case DioExceptionType.unknown:
        return UnknownFailure(message: ErrorConstants.unknownError.tr(), details: error.message);
    }
  }

  Failure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (statusCode) {
      case ResponseCode.UNAUTHORIZED:
        _handleUnauthorized();
        return UnauthenticatedFailure(
          message: ErrorConstants.unauthorizedError.tr(),
          details: _extractErrorMessage(responseData),
        );

      case ResponseCode.FORBIDDEN:
        return UnauthorizedFailure(
          message: ErrorConstants.forbiddenError.tr(),
          details: _extractErrorMessage(responseData),
        );

      case ResponseCode.NOT_FOUND:
        return ServerFailure(
          message: ErrorConstants.notFoundError.tr(),
          statusCode: ResponseCode.NOT_FOUND,
          details: _extractErrorMessage(responseData),
        );

      case ResponseCode.BLOCKED:
        return UserBlockedFailure(
          message: ErrorConstants.blockedError.tr(),
          details: _extractErrorMessage(responseData),
        );

      case ResponseCode.NOT_ALLOWED:
        return UserNotAllowedFailure(
          message: ErrorConstants.notAllowed.tr(),
          details: _extractErrorMessage(responseData),
        );

      case ResponseCode.Bad_Content:
      case ResponseCode.BAD_REQUEST:
      case ResponseCode.BAD_REQUEST_Server:
        return ServerFailure(
          message: _extractErrorMessage(responseData) ?? ErrorConstants.badRequestError.tr(),
          statusCode: statusCode ?? ResponseCode.BAD_REQUEST,
        );

      case ResponseCode.INTERNAL_SERVER_ERROR:
        return ServerFailure(
          message: ErrorConstants.internalServerError.tr(),
          statusCode: ResponseCode.INTERNAL_SERVER_ERROR,
          details: _extractErrorMessage(responseData),
        );

      default:
        return ServerFailure(
          message: _extractErrorMessage(responseData) ?? ErrorConstants.unknownError.tr(),
          statusCode: statusCode ?? ResponseCode.DEFAULT,
        );
    }
  }

  String _getTimeoutMessage(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return ErrorConstants.connectTimeoutError;
      case DioExceptionType.sendTimeout:
        return ErrorConstants.sendTimeoutError;
      case DioExceptionType.receiveTimeout:
        return ErrorConstants.receiveTimeoutError;
      default:
        return ErrorConstants.defaultError;
    }
  }

  String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    try {
      final errorModel = ErrorMessageModel.fromJson(responseData);
      return errorModel.statusMessage;
    } catch (e) {
      return responseData.toString();
    }
  }

  void _handleUnauthorized() {
    if (BaseRouter.routerConfig.canPop()) {
      BaseRouter.routerConfig.pop();
    }
    AppRoutes.onboarding.go();
    Toaster.showToast(ErrorConstants.unauthorizedError.tr());
  }

  void _logError(dynamic error) {
    log(name: 'ErrorHandler', error.toString(), error: failure, stackTrace: error is Error ? error.stackTrace : null);
  }
}

// Enhanced Extension for Better Error Handling
extension DioExceptionExtension on Future<Response> {
  Result<T> toResult<T>(FromJson<T> jsonConvert, {bool fullParse = false}) async {
    try {
      final result = await this;
      if (_isSuccessStatusCode(result.statusCode)) {
        return Right(parseBaseResponse(result.data, jsonConvert));
      } else {
        final failure = _createFailureFromResponse(result);
        return Left(failure);
      }
    } catch (e) {
      final failure = ErrorHandler.handle(e).failure;
      return Left(failure);
    }
  }

  bool _isSuccessStatusCode(int? statusCode) {
    return statusCode == ResponseCode.SUCCESS ||
        statusCode == ResponseCode.CREATED ||
        statusCode == ResponseCode.NO_CONTENT;
  }

  Failure _createFailureFromResponse(Response result) {
    return ServerFailure(
      message: ErrorConstants.badRequestError.tr(),
      statusCode: result.statusCode ?? ResponseCode.BAD_REQUEST,
      details: result.data?.toString(),
    );
  }
}
