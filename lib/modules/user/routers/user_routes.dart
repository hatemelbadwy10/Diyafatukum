import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/extensions/widget_extensions.dart';
import '../../../core/config/router/app_route.dart';
import '../../../core/config/router/page_transition.dart';
import '../../../core/config/router/route_manager.dart';
import '../../../core/config/service_locator/injection.dart';
import '../../common/features/bag/presentation/controller/bag_cubit/bag_cubit.dart';
import '../../common/features/bag/presentation/view/screens/bag_screen.dart';
import '../../common/features/orders/data/model/order_model.dart';
import '../../common/features/orders/presentation/controller/orders_cubit/orders_cubit.dart';
import '../../common/features/orders/presentation/view/screens/orders_screen.dart';
import '../../common/features/orders/presentation/view/screens/single_order_screen.dart';
import '../../common/features/notifications/presentation/controller/notifications_cubit/notifications_cubit.dart';
import '../../common/features/notifications/presentation/view/screens/notifications_screen.dart';
import '../../common/features/profile/presentation/view/screens/profile_screen.dart';
import '../../common/features/profile/presentation/view/screens/phone_screen.dart';
import '../../common/features/auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../common/features/shared/presentation/view/screens/scaffold_with_nav_bar_screen.dart';
import '../../common/features/settings/data/model/static_page_enum.dart';
import '../../common/features/settings/presentation/view/screens/contact_us_screen.dart';
import '../../common/features/settings/presentation/view/screens/settings_screen.dart';
import '../../common/features/settings/presentation/view/screens/static_page_screen.dart';
import '../features/home/data/model/user_home_model.dart';
import '../features/home/presentation/view/screens/user_home_screen.dart';
import '../features/single_service/presentation/view/screens/single_service_screen.dart';
import '../features/single_service/presentation/view/screens/single_service_store_screen.dart';
import '../features/single_service/data/model/single_service_store_model.dart';

/// User-specific routes for the User app
class UserRoutes extends BaseRouter {
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
        StatefulShellBranch(routes: _bagRoutes),
        StatefulShellBranch(routes: _settingsRoutes),
      ],
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.profile.path,
      name: AppRoutes.profile.name,
      pageBuilder: (context, state) => const ProfileScreen().buildPage(
        transition: PageTransitions.cupertino,
      ),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.contact.path,
      name: AppRoutes.contact.name,
      pageBuilder: (context, state) => const ContactUsScreen().buildPage(
        transition: PageTransitions.cupertino,
      ),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.notifications.path,
      name: AppRoutes.notifications.name,
      pageBuilder: (context, state) {
        final authCubit = context.read<AuthCubit>();
        return BlocProvider(
          create: (_) => NotificationsCubit(
            sl(),
            authCubit.state.user.notificationEnabled,
          ),
          child: const NotificationsScreen(),
        ).buildPage(transition: PageTransitions.cupertino);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.phone.path,
      name: AppRoutes.phone.name,
      pageBuilder: (context, state) =>
          const PhoneScreen().buildPage(transition: PageTransitions.cupertino),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.staticPage.path,
      name: AppRoutes.staticPage.name,
      pageBuilder: (context, state) {
        final type = state.extra as StaticPage?;
        if (type == null) {
          return const Scaffold().buildPage();
        }
        return StaticPageScreen(
          type: type,
        ).buildPage(transition: PageTransitions.cupertino);
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
        ).buildPage(transition: PageTransitions.cupertino);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.singleService.path,
      name: AppRoutes.singleService.name,
      pageBuilder: (context, state) {
        final service = state.extra as UserHomeServiceModel?;
        if (service == null) {
          return const Scaffold().buildPage();
        }
        return SingleServiceScreen(
          service: service,
        ).buildPage(transition: PageTransitions.cupertino);
      },
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoutes.singleServiceStore.path,
      name: AppRoutes.singleServiceStore.name,
      pageBuilder: (context, state) {
        final arguments = state.extra as SingleServiceStoreScreenArguments?;
        if (arguments == null) {
          return const Scaffold().buildPage();
        }
        return SingleServiceStoreScreen(
          arguments: arguments,
        ).buildPage(transition: PageTransitions.cupertino);
      },
    ),
  ];

  /// User routes
  static List<RouteBase> get _homeRoutes => [
    GoRoute(
      path: AppRoutes.home.path,
      name: AppRoutes.home.name,
      pageBuilder: (context, state) => const UserHomeScreen().buildPage(),
    ),
  ];

  static List<RouteBase> get _bagRoutes => [
    GoRoute(
      path: AppRoutes.bag.path,
      name: AppRoutes.bag.name,
      pageBuilder: (context, state) => BlocProvider(
        create: (_) => sl<BagCubit>()..loadBag(),
        child: const BagScreen(),
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

  static List<RouteBase> get _settingsRoutes => [
    GoRoute(
      path: AppRoutes.settings.path,
      name: AppRoutes.settings.name,
      pageBuilder: (context, state) => const SettingsScreen().buildPage(),
    ),
  ];
}
