import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import '../data/error/failure.dart';
import '../resources/resources.dart';

abstract class LocationService {
  Future<Either<Failure, Position>> getCurrentLocation();
}

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Left(LocationFailure(message: LocaleKeys.error_location_service_disabled.tr()));
      }

      // Check location permission status
      await LocationUtils.handleLocationPermissionStatus();

      // Permission granted, get current position
      final position = await Geolocator.getCurrentPosition();
      return Right(position);
    } catch (e) {
      return Left(LocationFailure(message: LocaleKeys.error_location_message.tr()));
    }
  }
}

class LocationUtils {
  static Completer<void>? _permissionCompleter;

  static Future<void> handleLocationPermissionStatus() async {
    // If a request is already in progress, return its Future
    if (_permissionCompleter != null) return _permissionCompleter!.future;

    _permissionCompleter = Completer<void>();

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationFailure(message: LocaleKeys.error_location_permission_denied.tr());
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationFailure(message: LocaleKeys.error_location_permission_denied.tr());
      }

      _permissionCompleter!.complete(); // success
    } catch (e) {
      _permissionCompleter!.completeError(e); // fail
    } finally {
      _permissionCompleter = null; // allow future requests
    }
  }

  /// Opens device location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Opens the app settings page
  static Future<bool> openAppSettings() async {
    return await permission.openAppSettings();
  }

  /// Checks if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// Handles the case when location permission is permanently denied
  static Future<bool> handlePermanentlyDeniedPermission() async {
    return await permission.openAppSettings();
  }

  /// get location stream work in background
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(locationSettings: settings);
  }

  // get android location settings
  static LocationSettings get settings {
    if (Platform.isIOS) {
      return AppleSettings(
        distanceFilter: 100,
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        allowBackgroundLocationUpdates: true,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    }
    return AndroidSettings(accuracy: LocationAccuracy.high, forceLocationManager: true);
  }
}
