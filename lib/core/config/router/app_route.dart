import 'route_manager.dart';

class AppRoutes extends BaseRoute {
  const AppRoutes(super.name, super.path);

  static const splash = AppRoutes('splash', '/');
  static const onboarding = AppRoutes('onboarding', '/onboarding');

  // auth
  static const login = AppRoutes('login', '/login');
  static const register = AppRoutes('register', '/register');
  static const registerDetails = AppRoutes('registerDetails', '/register/details');

  // forget password
  static const forgetPassword = AppRoutes('forgetPassword', '/forget-password');
  static const resetPassword = AppRoutes('resetPassword', '/reset-password');

  // verification
  static const verification = AppRoutes('verification', '/verification');

  // side menu
  static const moreMenu = AppRoutes('moreMenu', '/more-menu');
  static const settings = AppRoutes('settings', '/settings');
  static const contact = AppRoutes('contact', '/contact');
  static const staticPage = AppRoutes('staticPage', '/static-page');
  static const faq = AppRoutes('faq', '/faq');
  static const wallet = AppRoutes('wallet', '/wallet');
  static const coupons = AppRoutes('coupons', '/coupons');

  // address
  static const addresses = AppRoutes('addresses', '/addresses');
  static const addressDetails = AppRoutes('addressDetails', '/address-details');
  static const map = AppRoutes('map', '/map');

  // store
  static const store = AppRoutes('store', '/store');
  static const products = AppRoutes('products', '/products');

  // orders
  static const orders = AppRoutes('orders', '/orders');
  static const orderDetails = AppRoutes('orderDetails', '/order-details');

  // home
  static const home = AppRoutes('home', '/home');
  static const singleService = AppRoutes('singleService', '/single-service');
  static const singleServiceStore = AppRoutes(
    'singleServiceStore',
    '/single-service-store',
  );
  static const providerHome = AppRoutes('providerHome', '/provider-home');
  static const providerRegisterLocation = AppRoutes(
    'providerRegisterLocation',
    '/provider-home/location',
  );

  // stationery
  static const auctions = AppRoutes('auctions', '/auctions');

  // shopping bag
  static const bag = AppRoutes('shoppingBag', '/shopping-bag');
  static const checkout = AppRoutes('checkout', '/checkout');

  // profile
  static const profile = AppRoutes('profile', '/profile');
  static const editProfile = AppRoutes('editProfile', '/edit-profile');
  static const phone = AppRoutes('phone', '/phone');

  // notifications
  static const notifications = AppRoutes('notifications', '/notifications');
}
