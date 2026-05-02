import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../config/flavor/flavor_config.dart';
import 'environment_keys.dart';

class RemoteUrls {
  /// Base url for the api
  static String get baseUrl =>
      dotenv.env[EnvironmentKeys.apiBaseUrl] ?? 'add your base url here';

  /// Current flavor endpoint
  static String get flavor => FlavorConfig.currentFlavor.endpoint;

  /// Auth
  static String login = 'auth/login';
  static String register = 'auth/register-user';
  static String providerRegister = '$flavor/register';
  static String logout = 'auth/logout';

  /// Forget Password
  static String forgetPassword = 'auth/forgot-password';
  static String resetPassword = 'auth/reset-password';

  /// Verification
  static String verifyAccount = 'auth/verify-otp';
  static String verifyPassword = 'auth/verify-otp';
  static String verifyPhone = 'auth/verify-otp';

  static String resendCode = '$flavor/verification/send';
  static String resendPasswordCode = 'auth/forgot-password';
  static String resendPhoneCode = 'user/phone';

  /// Profile
  static String profile = 'user/profile';
  static String changePhone = 'user/phone';
  static String changeEmail = 'user/email';
  static String changePassword = 'user/profile/password';
  static String deleteAccount = '$flavor/delete';

  /// Notifications
  static String notifications = 'user/notifications';
  static String markNotificationRead(String id) =>
      'user/notifications/$id/read';
  static String notificationSettings = 'user/notifications/settings';

  /// Orders
  static String get orders =>
      FlavorConfig.isParent ? 'user/orders' : '$flavor/orders';
  static String orderDetails(String id) =>
      FlavorConfig.isParent ? 'user/orders/$id' : '$flavor/orders/$id';
  static String cancelOrder(String id) => FlavorConfig.isParent
      ? 'user/orders/$id/cancel'
      : '$flavor/orders/$id/cancel';
  static String trackOrder(String id) => FlavorConfig.isParent
      ? 'user/orders/$id/track'
      : '$flavor/orders/$id/track';
  static String providerDashboard = '$flavor/home';
  static String providerStore = '$flavor/store';

  /// User Home
  static String userHome = 'home';
  static String singleService(String serviceKey) =>
      'specializations/$serviceKey';
  static String singleServiceStore(String serviceKey, String storeId) =>
      'stores/$storeId';

  /// Cart
  static String cart = 'user/cart';
  static String cartItems = 'user/cart/items';
  static String cartItem(String id) => 'user/cart/items/$id';
  static String checkout = 'user/checkout';

  /// Settings
  static const String contact = 'user/support';
  static const String contacts = 'contact';

  static String language = '$flavor/preferred-locale';

  /// Static Pages
  static const String about = 'pages/about';
  static const String terms = 'pages/terms';
  static const String privacy = 'pages/privacy';
  static const String cancellationRefund = 'pages/cancellation-refund';
  static const String faq = 'faqs';

  /// Addresses
  static String addresses = '$flavor/addresses';
  static String address(String id) => '$flavor/addresses/$id';
  static String setDefaultAddress(String id) => 'addresses/$id/default';
}
