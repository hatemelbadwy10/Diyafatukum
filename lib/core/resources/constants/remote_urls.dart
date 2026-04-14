import 'package:deals/core/config/flavor/flavor_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'environment_keys.dart';

class RemoteUrls {
  /// Base url for the api
  static String get baseUrl => dotenv.env[EnvironmentKeys.apiBaseUrl] ?? 'add your base url here';

  /// Current flavor endpoint
  static String get flavor => FlavorConfig.currentFlavor.endpoint;

  /// Auth
  static String login = 'login';
  static String register = 'register';
  static String logout = 'logout';

  /// Forget Password
  static String forgetPassword = '$flavor/password/forget';
  static String resetPassword = '$flavor/password/reset';

  /// Verification
  static String verifyAccount = '$flavor/verification/verify';
  static String verifyPassword = '$flavor/password/code';
  static String verifyPhone = '$flavor/authenticable/verify';

  static String resendCode = '$flavor/verification/send';
  static String resendPasswordCode = '$flavor/password/forget';
  static String resendPhoneCode = '$flavor/authenticable/update';

  /// Profile
  static String profile = '$flavor/profile';
  static String changePhone = '$flavor/authenticable/update';
  static String changePassword = '$flavor/profile/password/update';
  static String deleteAccount = '$flavor/delete';

  /// Notifications

  /// Settings
  static const String contact = 'contact-us';
  static const String contacts = 'contact';

  static String language = '$flavor/preferred-locale';

  /// Static Pages
  static const String about = 'about';
  static const String terms = 'terms';
  static const String privacy = 'privacy';
  static const String faq = 'faqs';

  /// Addresses
  static String addresses = '$flavor/addresses';
  static String address(String id) => '$flavor/addresses/$id';
  static String setDefaultAddress(String id) => 'addresses/$id/default';
}
