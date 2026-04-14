import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/resources.dart';
import '../../utils/geocoding_utils.dart';

extension ImageSourceExt on ImageSource {
  SvgGenImage get icon {
    switch (this) {
      case ImageSource.camera:
        return Assets.icons.boxiconsCamera;
      case ImageSource.gallery:
        return Assets.icons.boxiconsCamera;
    }
  }

  String get title {
    switch (this) {
      case ImageSource.camera:
        return LocaleKeys.image_source_camera.tr();
      case ImageSource.gallery:
        return LocaleKeys.image_source_gallery.tr();
    }
  }
}

extension FileExt on XFile {
  int get size {
    return File(path).lengthSync();
  }
}

extension LatLngExtension on LatLng? {
  //validates if the LatLng is not null and returns a default value if it is.
  LatLng get orDefault => this ?? const LatLng(30.0444, 31.2357);

  /// Converts a [LatLng] to a [Map] representation.
  Map<String, double> toMap() {
    return {'latitude': orDefault.latitude, 'longitude': orDefault.longitude};
  }

  /// Converts a [LatLng] to a human-readable address using reverse geocoding.
  Future<String?> toAddress() async {
    return await GeocodingUtils.getFullAddressFromLatLng(orDefault);
  }

  /// Converts a [LatLng] to a [Placemark] object using reverse geocoding.
  Future<Placemark?> toPlacemark() async {
    return await GeocodingUtils.getPlacemarkFromLatLng(orDefault);
  }
}


extension PositionExtension on Position? {
  Position validate() {
    return this!;
  }

  LatLng? toLatLng() {
    return LatLng(validate().latitude, validate().longitude);
  }

  Map<String, double> toMap() {
    return {'latitude': validate().latitude, 'longitude': validate().longitude};
  }
}
