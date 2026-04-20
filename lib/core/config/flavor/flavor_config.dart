import 'flavor_type_enum.dart';

class FlavorConfig {
  static FlavorType? _currentFlavor;

  static FlavorType get currentFlavor => _currentFlavor!;

  static bool get isParent => _currentFlavor == FlavorType.user;
  static bool get isProvider   => _currentFlavor == FlavorType.provider;
  static String get displayName => currentFlavor.displayName;

  static void initialize(FlavorType flavor) {
    _currentFlavor = flavor;
  }

  static Future<void> initializeFirebase() async {}
}
