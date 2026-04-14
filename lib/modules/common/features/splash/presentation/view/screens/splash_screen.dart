import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/theme/light_theme.dart';
import '../../../../../../../core/resources/resources.dart';

import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';
import '../../controller/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    bottomNavNotifier.value = NavigationBarItems.home;
    context.read<AuthCubit>().checkAuthStatus();
    _controller = AnimationController(vsync: this, duration: 1.0.seconds);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.status.listen(
          onAuthorized: () {
            _controller.reverse();
            Future.delayed(500.0.milliseconds, () => AppRoutes.home.go());
            // RemoteNotificationServices.handleInitialNotification();
          },
          onUnauthorized: () {
            _controller.reverse();
            final bool skipOnboarding = context.read<SplashCubit>().state.isOnboardingViewed;
            if (skipOnboarding) {
              Future.delayed(500.0.milliseconds, () async => AppRoutes.home.go());
            } else {
              Future.delayed(500.0.milliseconds, () => AppRoutes.onboarding.go());
            }
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: LightThemeColors.primary,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Assets.icons.iconParkOutlineTransactionOrder.svg(fit: BoxFit.cover).opacity(opacity: 0.5),
              Assets.images.logoBLight.image(height: 120).center().animate(controller: _controller).fadeIn(),
            ],
          ),
        );
      },
    );
  }
}
