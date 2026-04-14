import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../resources/resources.dart';
import 'overlay_utils.dart';

class MediaServices {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<XFile>> pickMultipleImages({int? maxImages}) async {
    try {
      final images = await _picker.pickMultiImage(imageQuality: 100, limit: maxImages);
      return images;
    } catch (e) {
      final check = await handelPermission();
      if (check != true) return [];
      final images = await _picker.pickMultiImage(imageQuality: 100, limit: maxImages);
      return images;
    }
  }

  static Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final image = await _picker.pickImage(source: source, imageQuality: 100);
      return image;
    } catch (e) {
      final check = await handelPermission();
      if (check != true) return null;
      final image = await _picker.pickImage(source: source, imageQuality: 100);
      return image;
    }
  }

  static Future<XFile?> pickVideo({ImageSource source = ImageSource.gallery}) async {
    try {
      final video = await _picker.pickVideo(source: source);
      return video;
    } catch (e) {
      final check = await handelPermission(isVideo: true);
      if (check != true) return null;
      final video = await _picker.pickImage(source: source, imageQuality: 100);
      return video;
    }
  }

  static Future<XFile?> pickMedia() async {
    try {
      final media = await _picker.pickMedia();
      return media;
    } catch (e) {
      final check = await handelPermission();
      if (check != true) return null;
      final media = await _picker.pickMedia();
      return media;
    }
  }

  static Future<bool> handelPermission({bool isVideo = false}) async {
    late PermissionStatus status;
    late AndroidDeviceInfo androidInfo;
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
    }
    if (Platform.isAndroid && androidInfo.version.sdkInt <= 32) {
      status = await Permission.storage.request();
    } else {
      if (isVideo) {
        status = await Permission.videos.request();
      } else {
        status = await Permission.photos.request();
      }
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      await OverlayUtils.openSettingPermissionDialog(message: LocaleKeys.permissions_camera_gallery.tr());
    } else {
      return true;
    }
    return false;
  }
}
