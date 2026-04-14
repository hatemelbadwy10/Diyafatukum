import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../resources/constants/environment_keys.dart';
import '../resources/constants/platform_channels_constants.dart';

class PlatformChannelsUtils {
  static const MethodChannel _channel = MethodChannel(PlatformChannelsConstants.configChannel);

  static Future<void> setGoogleMapsApiKey() async {
    try {
      await _channel.invokeMethod(PlatformChannelsConstants.setGoogleMapsApiKey, {
        'apiKey': dotenv.env[EnvironmentKeys.googleMapsApiKey] ?? '',
      });
    } catch (e) {
      debugPrint('Failed to set Google Maps API key: $e');
    }
  }
}
