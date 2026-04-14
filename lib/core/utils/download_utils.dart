import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/service_locator/injection.dart';
import '../data/client/api_client.dart';
import '../resources/enums/download_status.dart';
import '../resources/resources.dart';

/// A utility class for handling download-related operations
class DownloadUtils {
  static ApiClient apiClient = sl<ApiClient>();
  static final DownloadUtils instance = DownloadUtils._internal();

  DownloadUtils._internal();

  /// Checks if the app has the necessary permissions for downloading files
  /// Returns true if permissions are granted, false otherwise
  Future<bool> checkPermissions() async {
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = deviceInfo.version.sdkInt;
      if (sdkInt >= 29) {
        // Android 10 and above: Use scoped storage, no special permissions needed for app-specific directories
        return true;
      } else {
        // Android 9 and below: Still need WRITE_EXTERNAL_STORAGE for external directories
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS doesn't need explicit permissions for downloading to app directory
      return true;
    }
    return false;
  }

  /// Gets the appropriate directory for downloading files based on the platform
  Future<Directory?> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // For Android, use app-specific external files directory
      // This doesn't require special permissions and files are accessible by the app
      // Files will be removed when app is uninstalled but are still accessible for opening
      return await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      // For iOS, use the Documents directory
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  /// Verifies if a file already exists at the given path
  Future<bool> fileExists(String filePath) async {
    final file = File(filePath);
    return await file.exists();
  }

  /// Builds the complete download URL based on the provided file URL and base URL
  /// Ensures the URL has the proper scheme and path
  String buildDownloadUrl(String fileUrl, String baseUrl) {
    if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
      if (fileUrl.startsWith('/')) {
        // URL is an absolute path without scheme, prepend base URL without path
        Uri baseUri = Uri.parse(baseUrl);
        String baseUrlWithoutPath = '${baseUri.scheme}://${baseUri.authority}';
        return '$baseUrlWithoutPath$fileUrl';
      } else {
        // URL is relative, prepend full base URL
        return baseUrl + fileUrl;
      }
    }
    return fileUrl;
  }

  /// Creates a file path for the download by combining directory path and filename
  Future<String?> createFilePath(String fileName) async {
    final directory = await getDownloadDirectory();
    if (directory == null) {
      return null;
    }
    return '${directory.path}/$fileName';
  }

  /// Checks if a file is already downloaded for a given item
  /// Returns a completed download status if the file exists, null otherwise
  Future<DownloadStatus?> getDownloadStatusForItem(int itemId, String fileUrl) async {
    final fileName = path.basename(fileUrl);
    final filePath = await createFilePath(fileName);

    if (filePath != null && await fileExists(filePath)) {
      return DownloadStatus.completed(filePath: filePath, progress: 1.0, itemId: itemId);
    }

    return null;
  }

  /// Gets the file path for a given item's file URL
  Future<String?> getFilePathForItem(String fileUrl) async {
    final fileName = path.basename(fileUrl);
    return await createFilePath(fileName);
  }

  /// Downloads a file and provides status updates through a DownloadStatus object
  ///
  /// Parameters:
  /// - [id]: Unique identifier for the download (e.g., item ID)
  /// - [url]: URL of the file to download
  /// - [fileName]: Name to save the file as
  /// - [baseUrl]: Optional base URL for relative URLs
  ///
  /// Returns a DownloadStatus object that can be used with onSuccess, onFailure, and onProgress callbacks
  Future<DownloadStatus> download<T>({
    required int id,
    required String url,
    required String fileName,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final baseUrl = apiClient.dio.options.baseUrl;
    // Check permissions
    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      return DownloadStatus<T>.failed(message: LocaleKeys.error_download_permission_denied.tr(), itemId: id);
    }

    // Create file path
    final filePath = await createFilePath(fileName);
    if (filePath == null) {
      return DownloadStatus<T>.failed(message: LocaleKeys.error_download_permission_storage.tr(), itemId: id);
    }

    // Check if file already exists
    if (await fileExists(filePath)) {
      return DownloadStatus<T>.completed(filePath: filePath, progress: 1.0, itemId: id);
    }

    // Build download URL with base URL if provided
    String downloadUrl = url;
    if (baseUrl.isNotEmpty) {
      downloadUrl = buildDownloadUrl(url, baseUrl);
    }

    try {
      // If apiClient is not provided, we can't proceed with download
      await apiClient.downloadFile(
        downloadUrl,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(responseType: ResponseType.bytes, headers: {'Accept': '*/*'}),
      );

      // Return completed status after successful download
      return DownloadStatus<T>.completed(filePath: filePath, progress: 1.0, itemId: id);
    } catch (e) {
      String errorMessage;
      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          errorMessage = 'Download cancelled';
        } else {
          // Other Dio errors with more detailed message
          final statusCode = e.response?.statusCode;
          switch (statusCode) {
            case 404:
              errorMessage = LocaleKeys.error_download_not_found.tr();
              break;
            case 408:
              errorMessage = LocaleKeys.error_dio_receive_timeout.tr();

              break;
            default:
              errorMessage = LocaleKeys.error_download_message.tr();
          }
        }
      } else {
        errorMessage = LocaleKeys.error_download_message.tr();
      }

      return DownloadStatus<T>.failed(message: errorMessage, itemId: id);
    }
  }
}
