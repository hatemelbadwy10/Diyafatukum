import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/extensions/widget_extensions.dart';
import '../../../core/config/router/app_route.dart';
import '../../../core/config/router/route_manager.dart';
import '../../common/features/shared/presentation/view/screens/scaffold_with_nav_bar_screen.dart';

/// User-specific routes for the User app
class UserRoutes extends BaseRouter {
  @override
  void registerRoutes() => BaseRouter.routes.addAll(routes);

  static List<RouteBase> get routes => [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state, shell) => ScaffoldWithNavBarScreen(shell: shell).buildPage(),
      branches: [StatefulShellBranch(routes: _homeRoutes)],
    ),
  ];

  /// User routes
  static List<RouteBase> get _homeRoutes => [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      pageBuilder: (context, state) => const Scaffold().buildPage(),
    ),
  ];
}
