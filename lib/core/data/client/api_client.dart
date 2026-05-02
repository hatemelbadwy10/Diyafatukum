import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';

import '../../config/router/route_manager.dart';
import '../../resources/constants/localization_constants.dart';
import '../../resources/constants/remote_urls.dart';
import '../../resources/type_defs.dart';
import 'logger_interceptor.dart';

@LazySingleton()
class ApiClient {
  final LoggerInterceptor loggingInterceptor;
  late Dio dio;

  ApiClient(Dio dioC, {required this.loggingInterceptor}) {
    final normalizedBaseUrl = RemoteUrls.baseUrl.endsWith('/')
        ? RemoteUrls.baseUrl
        : '${RemoteUrls.baseUrl}/';

    dio = dioC;
    dio
      ..options.baseUrl = normalizedBaseUrl
      ..options.connectTimeout = const Duration(milliseconds: 60000)
      ..options.receiveTimeout = const Duration(milliseconds: 60000)
      ..httpClientAdapter
      ..options.headers = {
        'Accept': 'application/json',
        'lang':
            rootNavigatorKey.currentContext?.locale.languageCode ??
            LocalizationConstants.favoriteLang.languageCode,
      };
    dio.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(
    String uri, {
    ParamsMap queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    data,
  }) async {
    return await dio.get(
      uri,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await dio.put(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await dio.delete(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // download file method
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Options? options,
  }) async {
    // Log download info
    loggingInterceptor.logDownload('Starting download');
    loggingInterceptor.logDownload('URL: $url');
    loggingInterceptor.logDownload('Save path: $savePath');

    // Create a temporary options object if none was provided
    final downloadOptions = options ?? Options();

    // Ensure response type is bytes
    downloadOptions.responseType = ResponseType.bytes;

    // Check if the URL is an absolute URL (starts with http or https)
    final isAbsoluteUrl =
        url.startsWith('http://') || url.startsWith('https://');

    // Create a progress callback wrapper that logs the progress
    progressWrapper(received, total) {
      if (onReceiveProgress != null) {
        onReceiveProgress(received, total);
      }
      loggingInterceptor.logProgress(received, total);
    }

    // Use Dio without base URL for absolute URLs
    if (isAbsoluteUrl) {
      loggingInterceptor.logDownload('Using absolute URL directly');
      final Dio tempDio = Dio();
      tempDio.options.headers = dio.options.headers;
      tempDio.options.connectTimeout = const Duration(milliseconds: 60000);
      tempDio.options.receiveTimeout = const Duration(milliseconds: 60000);
      tempDio.interceptors.add(loggingInterceptor);

      return await tempDio.download(
        url,
        savePath,
        onReceiveProgress: progressWrapper,
        cancelToken: cancelToken,
        options: downloadOptions,
      );
    }

    loggingInterceptor.logDownload(
      'Using relative URL with base URL: ${dio.options.baseUrl}',
    );
    return await dio.download(
      url,
      savePath,
      onReceiveProgress: progressWrapper,
      cancelToken: cancelToken,
      options: downloadOptions,
    );
  }

  void updateToken(String? token) {
    final normalizedToken = token?.trim();
    if (normalizedToken == null || normalizedToken.isEmpty) {
      dio.options.headers.remove('Authorization');
      return;
    }

    dio.options.headers.update(
      'Authorization',
      (value) => 'Bearer $normalizedToken',
      ifAbsent: () => 'Bearer $normalizedToken',
    );
  }

  void updateLanguage(String language) =>
      dio.options.headers['lang'] = language;
}
