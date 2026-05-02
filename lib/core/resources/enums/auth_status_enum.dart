import 'package:flutter/cupertino.dart';

import '../../config/extensions/all_extensions.dart';

enum AuthStatus {
  loading,
  authorized,
  guest,
  failed,
  unauthorized;

  Widget build({
    Widget? onUnauthorized,
    Widget? onGuest,
    Widget? onLoading,
    Widget? onFailed,
    required Widget onAuthorized,
  }) {
    switch (this) {
      case AuthStatus.unauthorized:
        return onUnauthorized ?? const SizedBox.shrink();
      case AuthStatus.guest:
        return onGuest ?? onUnauthorized ?? const SizedBox.shrink();
      case AuthStatus.loading:
        return onLoading ?? const CupertinoActivityIndicator().center();
      case AuthStatus.authorized:
        return onAuthorized;
      case AuthStatus.failed:
        return onFailed ?? onAuthorized;
    }
  }

  void listen({
    void Function()? onLoading,
    void Function()? onAuthorized,
    void Function()? onGuest,
    void Function()? onUnauthorized,
    void Function()? onInit,
  }) {
    switch (this) {
      case AuthStatus.unauthorized:
        onUnauthorized?.call();
        break;
      case AuthStatus.guest:
        onGuest?.call();
        break;
      case AuthStatus.loading:
        onLoading?.call();
        break;
      case AuthStatus.authorized:
        onAuthorized?.call();
        break;
      case AuthStatus.failed:
        onUnauthorized?.call();
        break;
    }
  }

  bool get isFailed => this == AuthStatus.failed;

  bool get isLoading => this == AuthStatus.loading;

  bool get isUnauthorized => this == AuthStatus.unauthorized;

  bool get isAuthorized => this == AuthStatus.authorized;

  bool get isGuest => this == AuthStatus.guest;

  bool get isInit => this == AuthStatus.unauthorized;
}
