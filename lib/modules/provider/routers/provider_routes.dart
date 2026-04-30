import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/extensions/widget_extensions.dart';
import '../../../core/config/router/app_route.dart';
import '../../../core/config/router/page_transition.dart';
import '../../../core/config/router/route_manager.dart';
import '../../../core/config/service_locator/injection.dart';
import '../../common/features/orders/data/model/order_model.dart';
import '../../common/features/orders/presentation/controller/orders_cubit/orders_cubit.dart';
import '../../common/features/orders/presentation/view/screens/orders_screen.dart';
import '../../common/features/orders/presentation/view/screens/single_order_screen.dart';
import '../../common/features/settings/presentation/view/screens/settings_screen.dart';
import '../../common/features/shared/presentation/view/screens/scaffold_with_nav_bar_screen.dart';
import '../features/home/presentation/controller/provider_home_cubit/provider_home_cubit.dart';
import '../features/home/presentation/view/screens/provider_home_screen.dart';
import '../features/onboarding/presentation/view/screens/provider_register_location_screen.dart';
import '../features/onboarding/presentation/view/screens/provider_register_screen.dart';
import '../features/store/presentation/controller/provider_store_cubit/provider_store_cubit.dart';
import '../features/store/presentation/view/screens/provider_store_screen.dart';

class ProviderRoutes extends BaseRouter {
  @override
  void registerRoutes() => BaseRouter.routes.addAll(routes);

  static List<RouteBase> get routes => [
        StatefulShellRoute.indexedStack(
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (context, state, shell) =>
              ScaffoldWithNavBarScreen(shell: shell).buildPage(),
          branches: [
            StatefulShellBranch(routes: _homeRoutes),
            StatefulShellBranch(routes: _ordersRoutes),
            StatefulShellBranch(routes: _storeRoutes),
            StatefulShellBranch(routes: _settingsRoutes),
          ],
        ),
        GoRoute(
          path: AppRoutes.providerHome.path,
          name: AppRoutes.providerHome.name,
          pageBuilder: (context, state) =>
              const ProviderRegisterScreen().buildPage(),
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.providerRegisterLocation.path,
          name: AppRoutes.providerRegisterLocation.name,
          pageBuilder: (context, state) {
            final arguments = state.extra as ProviderRegisterLocationArguments?;
            if (arguments == null) {
              return const Scaffold().buildPage();
            }
            return ProviderRegisterLocationScreen(arguments: arguments)
                .buildPage(transition: PageTransitions.cupertino);
          },
        ),
        GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: AppRoutes.orderDetails.path,
          name: AppRoutes.orderDetails.name,
          pageBuilder: (context, state) {
            final order = state.extra as OrderModel?;
            if (order == null) {
              return const Scaffold().buildPage();
            }
            return SingleOrderScreen(
              order: order,
              isProviderView: true,
            ).buildPage(
              transition: PageTransitions.cupertino,
            );
          },
        ),
      ];

  static List<RouteBase> get _homeRoutes => [
        GoRoute(
          path: AppRoutes.home.path,
          name: AppRoutes.home.name,
          pageBuilder: (context, state) => BlocProvider(
            create: (_) => sl<ProviderHomeCubit>()..loadHome(),
            child: const ProviderHomeScreen(),
          ).buildPage(),
        ),
      ];

  static List<RouteBase> get _ordersRoutes => [
        GoRoute(
          path: AppRoutes.orders.path,
          name: AppRoutes.orders.name,
          pageBuilder: (context, state) => BlocProvider(
            create: (_) => sl<OrdersCubit>()..loadOrders(),
            child: const OrdersScreen(),
          ).buildPage(),
        ),
      ];

  static List<RouteBase> get _storeRoutes => [
        GoRoute(
          path: AppRoutes.store.path,
          name: AppRoutes.store.name,
          pageBuilder: (context, state) => BlocProvider(
            create: (_) => sl<ProviderStoreCubit>()..loadStore(),
            child: const ProviderStoreScreen(),
          ).buildPage(),
        ),
      ];

  static List<RouteBase> get _settingsRoutes => [
        GoRoute(
          path: AppRoutes.settings.path,
          name: AppRoutes.settings.name,
          pageBuilder: (context, state) => const SettingsScreen().buildPage(),
        ),
      ];
}
