import 'package:deals/modules/common/features/auth/presentation/view/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/extensions/all_extensions.dart';
import '../../../core/config/router/app_route.dart';
import '../../../core/config/router/page_transition.dart';
import '../../../core/config/router/route_manager.dart';
import '../../../core/config/service_locator/injection.dart';
import '../features/auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../features/splash/presentation/controller/splash_cubit.dart';
import '../features/splash/presentation/view/screens/onboarding_screen.dart';
import '../features/splash/presentation/view/screens/splash_screen.dart';

class CommonRouter extends BaseRouter {
  @override
  void registerRoutes() => BaseRouter.routes.addAll(routes);

  List<RouteBase> get routes => [..._authRoutes];
}

List<RouteBase> get _authRoutes => [
  GoRoute(
    name: AppRoutes.splash.name,
    path: AppRoutes.splash.path,
    pageBuilder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl<AuthCubit>()),
        BlocProvider<SplashCubit>(create: (_) => sl<SplashCubit>()),
      ],
      child: const SplashScreen(),
    ).buildPage(),
  ),
  GoRoute(
    name: AppRoutes.onboarding.name,
    path: AppRoutes.onboarding.path,
    pageBuilder: (context, state) => BlocProvider<SplashCubit>(
      create: (_) => sl<SplashCubit>(),
      child: const OnboardingScreen(),
    ).buildPage(),
  ),
  GoRoute(
    name: AppRoutes.login.name,
    path: AppRoutes.login.path,
    pageBuilder: (context, state) {
      return LoginScreen().buildPage();
    },
  ),
];

List<RouteBase> get _ordersRoutes => [
  GoRoute(
    parentNavigatorKey: rootNavigatorKey,
    path: AppRoutes.orders.path,
    name: AppRoutes.orders.name,
    pageBuilder: (context, state) => const Scaffold().buildPage(transition: PageTransitions.cupertino),
  ),
];

// More menu routes like profile, settings, static pages, etc. for both Provider and User apps
List<RouteBase> get moreMenuRoutes => [
  GoRoute(
    path: AppRoutes.moreMenu.path,
    name: AppRoutes.moreMenu.name,
    pageBuilder: (context, state) => const Scaffold().buildPage(),
    routes: [
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.settings.path,
        name: AppRoutes.settings.name,
        pageBuilder: (context, state) => const Scaffold().buildPage(transition: PageTransitions.cupertino),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.staticPage.path,
        name: AppRoutes.staticPage.name,
        pageBuilder: (context, state) {
          // type: state.extra as StaticPage
          return Scaffold().buildPage(transition: PageTransitions.cupertino);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.profile.path,
        name: AppRoutes.profile.name,
        pageBuilder: (context, state) => const Scaffold().buildPage(transition: PageTransitions.cupertino),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.coupons.path,
        name: AppRoutes.coupons.name,
        pageBuilder: (context, state) => const Scaffold().buildPage(transition: PageTransitions.cupertino),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.contact.path,
        name: AppRoutes.contact.name,
        pageBuilder: (context, state) => const Scaffold().buildPage(transition: PageTransitions.cupertino),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AppRoutes.phone.path,
        name: AppRoutes.phone.name,
        pageBuilder: (context, state) => const Scaffold().buildPage(transition: PageTransitions.cupertino),
      ),
      ..._ordersRoutes,
    ],
  ),
];
