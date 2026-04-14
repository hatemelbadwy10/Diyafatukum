import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;

class CompressUtil {
  static Future<MultipartFile?> compress(File? imageFile) async {
    if (imageFile != null) {
      final filePath = imageFile.path;
      final ext = path.extension(filePath).toLowerCase();

      // Check if the file extension is a supported image format
      if (ext != '.jpg' && ext != '.jpeg' && ext != '.png' && ext != '.gif' && ext != '.webp') {
        throw Exception('Unsupported image format');
      }

      // Generate a new output path for the compressed file
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jpg|.jpeg|.png|.gif|.webp'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = '${splitted}_out${filePath.substring(lastIndex)}';

      // Compress the image
      var result = await FlutterImageCompress.compressAndGetFile(
        imageFile.path,
        outPath,
        quality: 80,
      );

      if (result == null) {
        throw Exception('Failed to compress image');
      }

      // Return the compressed image as a MultipartFile
      final MultipartFile image = await MultipartFile.fromFile(result.path, filename: path.basename(result.path));
      return image;
    }
    return null;
  }
}
