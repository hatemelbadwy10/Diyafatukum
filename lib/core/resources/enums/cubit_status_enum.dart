import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/extensions/all_extensions.dart';
import '../../config/theme/light_theme.dart';
import '../../data/error/failure.dart';
import '../../data/models/base_response.dart';
import '../../widgets/custom_fallback_view.dart';
import '../resources.dart';

class CubitStatus<T> {
  CubitStatus._({this.data, this.message = '', this.error, required _State state}) : _state = state;

  final T? data;
  final Failure? error;
  final String message;
  final _State _state;

  factory CubitStatus.loading({T? data}) => CubitStatus._(state: _State.loading, data: data);

  factory CubitStatus.success({dynamic data, String? message}) {
    if (data is BaseResponse) {
      return CubitStatus._(data: data.data, message: message ?? data.message ?? '', state: _State.success, error: null);
    }
    return CubitStatus._(data: data, state: _State.success, message: message ?? '', error: null);
  }

  factory CubitStatus.failed({T? data, String message = '', Failure? error}) {
    return CubitStatus._(message: message, state: _State.failed, error: error);
  }

  factory CubitStatus.initial({T? data, String message = ''}) {
    return CubitStatus._(data: data, message: message, state: _State.init);
  }

  bool get isInit => _state == _State.init;
  bool get isLoading => _state == _State.loading;
  bool get isSuccess => _state == _State.success;
  bool get isFailed => _state == _State.failed;

  Widget build({
    Widget? Function()? onInit,
    Widget? Function()? onLoading,
    Widget? Function()? onFailed,
    required Widget Function(T data) onSuccess,
    bool enableLoading = true,
    void Function()? onRetry,
  }) {
    switch (_state) {
      case _State.init:
        return onInit?.call() ?? const SizedBox.shrink();
      case _State.loading:
        return enableLoading ? onLoading?.call() ?? const CupertinoActivityIndicator().center() : onSuccess(data as T);
      case _State.success:
        return onSuccess(data as T);
      case _State.failed:
        return onFailed?.call() ??
            CustomFallbackView(
              icon: Icon(Icons.error, color: LightThemeColors.error, size: 52),
              title: LocaleKeys.error_ops.tr(),
              subtitle: message,
              buttonLabel: onRetry != null ? LocaleKeys.actions_retry.tr() : null,
              onButtonPressed: onRetry != null ? () => onRetry.call() : null,
            );
    }
  }

  void listen({
    void Function()? onLoading,
    void Function(T data)? onSuccess,
    void Function(Failure message)? onFailed,
    void Function()? onInit,
  }) {
    switch (_state) {
      case _State.init:
        onInit?.call();
        break;
      case _State.loading:
        onLoading?.call();
        break;
      case _State.success:
        onSuccess?.call(data as T);
        break;
      case _State.failed:
        onFailed?.call(error ?? UnknownFailure(message: message));
        break;
    }
  }
}

enum _State { loading, success, failed, init }
