import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/flavor/flavor_config.dart';
import 'app_route.dart';
import '../../../modules/common/routes/common_routers.dart';
import '../../../modules/provider/routers/provider_routes.dart';
import '../../../modules/user/routers/user_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class RouteManager {
  static void configureRoutes() {
    BaseRouter.routes.clear();
    CommonRouter().registerRoutes();
    if (FlavorConfig.isProvider) {
      ProviderRoutes().registerRoutes();
    } else {
      UserRoutes().registerRoutes();
    }
  }
}

abstract class BaseRouter {
  static final routerConfig = GoRouter(
    routes: routes,
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    observers: [BotToastNavigatorObserver()],
    initialLocation: AppRoutes.splash.path,
  );

  void registerRoutes();
  static final List<RouteBase> routes = [];

  static bool contains(String path) {
    return routerConfig.routerDelegate.currentConfiguration.matches.any((element) {
      return element.matchedLocation.contains(path);
    });
  }

  static String get currentRoute => routerConfig.routerDelegate.currentConfiguration.fullPath;

  static String namedLocation(String name) => routerConfig.namedLocation(name);

  static Map<String, String> get queryParams => routerConfig.routerDelegate.currentConfiguration.uri.queryParameters;

  static String get currentRouteName {
    try {
      return routerConfig.routerDelegate.currentConfiguration.last.route.name ?? '';
    } catch (e) {
      return '';
    }
  }

  static String get matchedLocation => routerConfig.routerDelegate.state.matchedLocation;

  static void pop<T extends Object?>([T? result]) {
    if (rootNavigatorKey.currentState?.canPop() ?? false) {
      rootNavigatorKey.currentState?.pop(result);
    } else {
      routerConfig.pop(result);
    }
  }

  static void popUntilPath(String ancestorPath) {
    while (routerConfig.routerDelegate.currentConfiguration.matches.last.matchedLocation != ancestorPath) {
      if (!routerConfig.canPop()) {
        return;
      }
      pop();
    }
  }
}

class BaseRoute {
  final String name;
  final String path;

  const BaseRoute(this.name, this.path);

  /// Pushes the route with the given name onto the navigator.
  Future<T?> push<T extends Object?>({
    Object? extra,
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queries = const <String, dynamic>{},
  }) {
    return BaseRouter.routerConfig.pushNamed(name, extra: extra, queryParameters: queries, pathParameters: params);
  }

  /// Pushes a new route onto the navigator, and replaces the current route with the new route.
  void pushReplacement<T extends Object?>({
    Object? extra,
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queries = const <String, dynamic>{},
  }) {
    BaseRouter.routerConfig.pushReplacementNamed(name, extra: extra, queryParameters: queries, pathParameters: params);
  }

  /// Navigates to the specified route.
  void go<T extends Object?>({
    Object? extra,
    Map<String, String> params = const <String, String>{},
    Map<String, dynamic> queries = const <String, dynamic>{},
  }) {
    return BaseRouter.routerConfig.goNamed(name, extra: extra, queryParameters: queries, pathParameters: params);
  }

  bool get isCurrentRoute => BaseRouter.currentRouteName == name;
}
