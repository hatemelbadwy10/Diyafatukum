import 'dart:async';
import 'dart:developer' show log;

import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeocodingUtils {
  /// Converts a [LatLng] to a complete address string using reverse geocoding.
  /// Returns a detailed address including street, locality, administrative area, and country.
  static Future<String?> getFullAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return place.toAddressString();
      }
      return null;
    } catch (e) {
      log('Error retrieving full address: $e', name: 'GEOCODING');
      return null;
    }
  }

  /// Converts a [LatLng] to a [Placemark] object using reverse geocoding.
  /// Returns the first placemark containing detailed location information.
  static Future<Placemark?> getPlacemarkFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first;
      }
      return null;
    } catch (e) {
      log('Error retrieving placemark: $e', name: 'GEOCODING');
      return null;
    }
  }
}

extension PlacemarkExtension on Placemark {
  /// Converts the [Placemark] to a human-readable address string.
  /// Combines street, locality, administrative area, and country into a single string.
  String toAddressString() {
    List<String> addressParts = [];

    if (street?.isNotEmpty == true) addressParts.add(street!);
    if (subLocality?.isNotEmpty == true) addressParts.add(subLocality!);
    if (locality?.isNotEmpty == true) addressParts.add(locality!);
    if (administrativeArea?.isNotEmpty == true) addressParts.add(administrativeArea!);
    if (country?.isNotEmpty == true) addressParts.add(country!);

    return addressParts.join(', ');
  }

  // get Area name
  String get areaName {
    return (subLocality != null && subLocality!.isNotEmpty)
        ? subLocality!
        : (locality != null && locality!.isNotEmpty)
        ? locality!
        : (subAdministrativeArea != null && subAdministrativeArea!.isNotEmpty)
        ? subAdministrativeArea!
        : (administrativeArea != null && administrativeArea!.isNotEmpty)
        ? administrativeArea!
        : '';
  }
}
