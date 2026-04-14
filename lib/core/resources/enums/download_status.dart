import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../config/extensions/all_extensions.dart';
import '../../widgets/custom_fallback_view.dart';
import '../resources.dart';

/// Status of a download operation with its associated data
class DownloadStatus<T> {
  DownloadStatus._({
    this.data,
    this.message = '',
    this.progress = 0.0,
    this.filePath = '',
    this.itemId = -1,
    required _DownloadState state,
  }) : _state = state;

  final T? data;
  final String message;
  final double progress;
  final String filePath;
  final int itemId;
  final _DownloadState _state;

  /// Initial state for the download
  factory DownloadStatus.initial({int itemId = -1, String filePath = ''}) =>
      DownloadStatus._(state: _DownloadState.initial, itemId: itemId, filePath: filePath);

  /// State when download is in progress
  factory DownloadStatus.downloading({T? data, double progress = 0.0, int itemId = -1, String filePath = ''}) {
    return DownloadStatus._(
      data: data,
      state: _DownloadState.downloading,
      progress: progress,
      itemId: itemId,
      filePath: filePath,
    );
  }

  /// State when download completed successfully
  factory DownloadStatus.completed({T? data, double progress = 1.0, String filePath = '', int itemId = -1}) {
    return DownloadStatus._(
      data: data,
      state: _DownloadState.completed,
      progress: progress,
      filePath: filePath,
      itemId: itemId,
    );
  }

  /// State when download failed
  factory DownloadStatus.failed({T? data, String message = '', int itemId = -1}) {
    return DownloadStatus._(data: data, state: _DownloadState.failed, message: message, itemId: itemId);
  }

  /// Whether the download is in initial state
  bool get isInitial => _state == _DownloadState.initial;

  /// Whether the download is in progress
  bool get isDownloading => _state == _DownloadState.downloading;

  /// Whether the download completed successfully
  bool get isCompleted => _state == _DownloadState.completed;

  /// Whether the download failed
  bool get isFailed => _state == _DownloadState.failed;

  /// Builder function to handle different download states in the UI
  Widget build({
    Widget? onInitial,
    Widget? onDownloading,
    Widget? onFailed,
    required Widget Function(T? data, String filePath, double progress) onCompleted,
    Widget Function(double progress)? progressBuilder,
  }) {
    switch (_state) {
      case _DownloadState.initial:
        return onInitial ?? const SizedBox.shrink();
      case _DownloadState.downloading:
        return onDownloading ??
            (progressBuilder != null ? progressBuilder(progress) : const CupertinoActivityIndicator().center());
      case _DownloadState.completed:
        return onCompleted(data, filePath, progress);
      case _DownloadState.failed:
        return onFailed ??
            CustomFallbackView(
              icon: Assets.icons.weuiLockOutlined.svg(),
              title: LocaleKeys.error_ops.tr(),
              subtitle: message,
            ).center();
    }
  }

  /// Callback functions for handling different download states
  DownloadStatus<T> onSuccess(void Function(DownloadStatus<T> status) callback) {
    if (_state == _DownloadState.completed) {
      callback(this);
    }
    return this;
  }

  /// Callback for handling download failure
  DownloadStatus<T> onFailure(void Function(DownloadStatus<T> status) callback) {
    if (_state == _DownloadState.failed) {
      callback(this);
    }
    return this;
  }

  /// Callback for handling download progress
  DownloadStatus<T> onProgress(void Function(DownloadStatus<T> status) callback) {
    if (_state == _DownloadState.downloading) {
      callback(this);
    }
    return this;
  }

  /// Listen to all possible download states
  void listen({
    void Function()? onInitial,
    void Function(double progress, int itemId)? onDownloading,
    void Function(T? data, String filePath, int itemId)? onCompleted,
    void Function(String message, int itemId)? onFailed,
  }) {
    switch (_state) {
      case _DownloadState.initial:
        onInitial?.call();
        break;
      case _DownloadState.downloading:
        onDownloading?.call(progress, itemId);
        break;
      case _DownloadState.completed:
        onCompleted?.call(data, filePath, itemId);
        break;
      case _DownloadState.failed:
        onFailed?.call(message, itemId);
        break;
    }
  }
}

/// Internal state enum for download operations
enum _DownloadState { initial, downloading, completed, failed }
