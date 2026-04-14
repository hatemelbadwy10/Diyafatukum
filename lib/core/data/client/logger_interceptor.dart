
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoggerInterceptor extends Interceptor {
  // Custom atomic print function to prevent interruptions
  void _atomicPrint(String message, {bool isError = false}) {
    final lines = message.split('\n');
    final buffer = StringBuffer();

    for (final line in lines) {
      buffer.writeln(line);
    }

    final finalMessage = buffer.toString().trimRight();

    // Use developer.log for atomic printing
    developer.log(finalMessage, name: 'HTTP_INTERCEPTOR', level: isError ? 1000 : 800);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    final duration = _calculateDuration(options);

    final errorLog = StringBuffer();
    errorLog.writeln('╔══════════════════════════════════════════════════════════════');
    errorLog.writeln('║ ❌ ERROR: ${options.method} $requestPath');
    errorLog.writeln('╠══════════════════════════════════════════════════════════════');
    errorLog.writeln('║ Duration: ${duration}ms');
    errorLog.writeln('║ Status Code: ${err.response?.statusCode ?? 'N/A'}');
    errorLog.writeln('║ Error Type: ${err.type}');
    errorLog.writeln('║ Error Message: ${err.message}');

    if (err.response?.data != null) {
      errorLog.writeln('║ Response Data:');
      final responseData = _formatData(err.response!.data);
      for (final line in responseData.split('\n')) {
        if (line.trim().isNotEmpty) {
          errorLog.writeln('║   $line');
        }
      }
    }

    // Stack trace (first few lines only)
    errorLog.writeln('║ Stack Trace:');
    final stackLines = err.stackTrace.toString().split('\n').take(3);
    for (final line in stackLines) {
      if (line.trim().isNotEmpty) {
        errorLog.writeln('║   $line');
      }
    }

    errorLog.writeln('╚══════════════════════════════════════════════════════════════');

    _atomicPrint(errorLog.toString(), isError: true);
    return super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Store start time for duration calculation
    options.extra['start_time'] = DateTime.now().millisecondsSinceEpoch;

    final requestPath = '${options.baseUrl}${options.path}';
    final requestLog = StringBuffer();

    requestLog.writeln('╔══════════════════════════════════════════════════════════════');
    requestLog.writeln('║ 🚀 REQUEST: ${options.method} $requestPath');
    requestLog.writeln('╠══════════════════════════════════════════════════════════════');

    // Query parameters
    if (options.queryParameters.isNotEmpty) {
      requestLog.writeln('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        requestLog.writeln('║   $key: $value');
      });
    }

    // Headers
    if (options.headers.isNotEmpty) {
      requestLog.writeln('║ Headers:');
      options.headers.forEach((key, value) {
        // Hide sensitive headers
        final sanitizedValue = _sanitizeHeader(key, value);
        requestLog.writeln('║   $key: $sanitizedValue');
      });
    }

    // Request data
    if (options.data != null) {
      requestLog.writeln('║ Request Data:');
      final formattedData = _formatData(options.data);
      for (final line in formattedData.split('\n')) {
        if (line.trim().isNotEmpty) {
          requestLog.writeln('║   $line');
        }
      }
    }

    requestLog.writeln('╚══════════════════════════════════════════════════════════════');

    _atomicPrint(requestLog.toString());
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = _calculateDuration(response.requestOptions);
    final requestPath = '${response.requestOptions.baseUrl}${response.requestOptions.path}';

    final responseLog = StringBuffer();
    responseLog.writeln('╔══════════════════════════════════════════════════════════════');
    responseLog.writeln('║ ✅ RESPONSE: ${response.requestOptions.method} $requestPath');
    responseLog.writeln('╠══════════════════════════════════════════════════════════════');
    responseLog.writeln('║ Status Code: ${response.statusCode} ${response.statusMessage ?? ''}');
    responseLog.writeln('║ Duration: ${duration}ms');

    // Response headers
    // if (response.headers.map.isNotEmpty) {
    //   responseLog.writeln('║ Response Headers:');
    //   response.headers.map.forEach((key, value) {
    //     responseLog.writeln('║   $key: ${value.join(', ')}');
    //   });
    // }

    // Response data
    if (response.data != null) {
      responseLog.writeln('║ Response Data:');
      final formattedData = _formatData(response.data);
      final lines = formattedData.split('\n');

      // Limit response data lines for readability
      // const maxLines = 50;
      // final displayLines = lines.length > maxLines ? lines.take(maxLines).toList() : lines;

      for (final line in lines) {
        if (line.trim().isNotEmpty) {
          responseLog.writeln('║   $line');
        }
      }

      // if (lines.length > maxLines) {
      //   responseLog.writeln('║   ... (${lines.length - maxLines} more lines truncated)');
      // }
    }

    responseLog.writeln('╚══════════════════════════════════════════════════════════════');

    _atomicPrint(responseLog.toString());
    return super.onResponse(response, handler);
  }

  // Helper methods
  String _calculateDuration(RequestOptions options) {
    final startTime = options.extra['start_time'] as int?;
    if (startTime == null) return 'N/A';

    final endTime = DateTime.now().millisecondsSinceEpoch;
    return (endTime - startTime).toString();
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';

    try {
      if (data is FormData) {
        final buffer = StringBuffer();
        buffer.writeln('FormData:');

        // Fields
        if (data.fields.isNotEmpty) {
          buffer.writeln('  Fields:');
          for (final field in data.fields) {
            buffer.writeln('    ${field.key}: ${field.value}');
          }
        }

        // Files
        if (data.files.isNotEmpty) {
          buffer.writeln('  Files:');
          for (final file in data.files) {
            buffer.writeln('    ${file.key}: ${file.value.filename} (${file.value.length} bytes)');
          }
        }

        return buffer.toString().trimRight();
      } else if (data is String) {
        // Try to parse as JSON for better formatting
        try {
          final decoded = jsonDecode(data);
          const encoder = JsonEncoder.withIndent('  ');
          return encoder.convert(decoded);
        } catch (_) {
          return data;
        }
      } else {
        const encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      }
    } catch (e) {
      return data.toString();
    }
  }

  String _sanitizeHeader(String key, dynamic value) {
    // final sensitiveHeaders = ['authorization', 'cookie', 'set-cookie', 'x-api-key', 'access-token', 'refresh-token'];

    // if (sensitiveHeaders.contains(key.toLowerCase())) {
    //   return '***HIDDEN***';
    // }

    return value.toString();
  }

  void logDownload(String message) {
    _atomicPrint('Download: $message');
    // You can add more logging logic here if needed
  }

  void logProgress(int received, int total) {
    if (total > 0) {
      final percentage = (received / total * 100).toStringAsFixed(2);
      _atomicPrint('Download Progress: $percentage% ($received/$total bytes)');
    } else {
      _atomicPrint('Download Progress: $received bytes received');
    }
  }
}
