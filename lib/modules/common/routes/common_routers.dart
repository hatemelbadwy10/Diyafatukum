import 'package:deals/modules/common/features/auth/presentation/view/screens/login_screen.dart';
import 'package:deals/modules/common/features/forget_password/presentation/view/screens/forget_password_screen.dart';
import 'package:deals/modules/common/features/forget_password/presentation/view/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/extensions/all_extensions.dart';
import '../../../core/config/router/app_route.dart';
import '../../../core/config/router/page_transition.dart';
import '../../../core/config/router/route_manager.dart';
import '../../../core/config/service_locator/injection.dart';
import '../features/addresses/presentation/view/screens/map_screen.dart';
import '../features/auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../features/auth/presentation/view/screens/register_screen.dart';
import '../features/auth/presentation/view/screens/register_step_two_screen.dart';
import '../features/splash/presentation/controller/splash_cubit.dart';
import '../features/splash/presentation/view/screens/onboarding_screen.dart';
import '../features/splash/presentation/view/screens/splash_screen.dart';
import '../features/verification/data/model/verification_type_enum.dart';
import '../features/verification/presentation/view/screens/verification_screen.dart';

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
  GoRoute(
    name: AppRoutes.register.name,
    path: AppRoutes.register.path,
    pageBuilder: (context, state) {
      return RegisterScreen().buildPage();
    },
  ),
  GoRoute(
    name: AppRoutes.registerDetails.name,
    path: AppRoutes.registerDetails.path,
    pageBuilder: (context, state) {
      final args = state.extra as RegisterStepTwoArgs?;
      if (args == null) {
        return const Scaffold().buildPage();
      }
      return RegisterStepTwoScreen(args: args).buildPage();
    },
  ),
  GoRoute(
    name: AppRoutes.forgetPassword.name,
    path: AppRoutes.forgetPassword.path,
    pageBuilder: (context, state) {
      final args = state.extra as RegisterStepTwoArgs?;
      if (args == null) {
        return const ForgetPasswordScreen().buildPage();
      }
      return RegisterStepTwoScreen(args: args).buildPage();
    },
  ),
  GoRoute(
    name: AppRoutes.resetPassword.name,
    path: AppRoutes.resetPassword.path,
    pageBuilder: (context, state) {
      final extra = state.extra;
      final args = extra is Map<String, dynamic>
          ? extra
          : extra is Map
              ? Map<String, dynamic>.from(extra)
              : null;
      final token = args?['token'] as String?;
      final identifier = args?['identifier'] as String?;
      if (token == null || identifier == null) {
        return const Scaffold().buildPage();
      }
      return ResetPasswordScreen(
        token: token,
        identifier: identifier,
      ).buildPage();
    },
  ),
  GoRoute(
    name: AppRoutes.map.name,
    path: AppRoutes.map.path,
    pageBuilder: (context, state) => MapScreen(
      arguments: state.extra as MapScreenArguments?,
    ).buildPage(transition: PageTransitions.cupertino),
  ),
   GoRoute(
        name: AppRoutes.verification.name,
        path: AppRoutes.verification.path,
        pageBuilder: (context, state) {
          final extra = state.extra;
          VerificationType type = VerificationType.register;
          void Function()? onVerificationSuccess;
          if (extra is Map && extra['type'] != null) {
            type = extra['type'] as VerificationType;
          }
          if (extra is Map && extra['onVerificationSuccess'] != null) {
            onVerificationSuccess =
                extra['onVerificationSuccess'] as void Function()?;
          }
          return VerificationScreen(
            identifier: state.uri.queryParameters['identifier'] as String,
            code: state.uri.queryParameters['code'],
            type: type,
            onVerificationSuccess: onVerificationSuccess,
          ).buildPage(transition: PageTransitions.cupertino);
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
