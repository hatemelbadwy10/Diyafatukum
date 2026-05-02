import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/theme/light_theme.dart';
import '../../../../../../../core/resources/resources.dart';

import '../../../../auth/presentation/controller/auth_cubit/auth_cubit.dart';
import '../../../../shared/data/model/navigation_bar_items.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<Color?> _logoColorAnimation;
  VoidCallback? _pendingNavigation;
  bool _isAnimationFinished = false;

  @override
  void initState() {
    super.initState();
    bottomNavNotifier.value = NavigationBarItems.home;
    context.read<AuthCubit>().checkAuthStatus();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2150),
    );

    _alignmentAnimation = AlignmentTween(
      begin: const Alignment(0, -1.2),
      end: Alignment.center,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.46, curve: Curves.easeInOutCubic),
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween<double>(0.86),
        weight: 46,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.86, end: 0.98)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.98, end: 1.12)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 14,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.12, end: 1.18)
            .chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 22,
      ),
    ]).animate(_controller);

    _backgroundAnimation = ColorTween(
      begin: Colors.white,
      end: LightThemeColors.primary,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _logoColorAnimation = ColorTween(
      begin: LightThemeColors.primary,
      end: Colors.white,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isAnimationFinished = true;
        _navigateIfReady();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPendingNavigation(VoidCallback navigation) {
    _pendingNavigation = navigation;
    _navigateIfReady();
  }

  void _navigateIfReady() {
    if (!_isAnimationFinished || _pendingNavigation == null || !mounted) return;
    final navigation = _pendingNavigation!;
    _pendingNavigation = null;
    navigation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.status.listen(
          onAuthorized: () {
            _setPendingNavigation(() => AppRoutes.home.go());
            // RemoteNotificationServices.handleInitialNotification();
          },
          onGuest: () {
            _setPendingNavigation(() => AppRoutes.home.go());
          },
          onUnauthorized: () {
            _setPendingNavigation(() => AppRoutes.onboarding.go());
          },
        );
      },
      builder: (context, state) {
        final double logoWidth = (context.width * 0.5).clamp(200.0, 290.0);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final Color backgroundColor = _backgroundAnimation.value ?? Colors.white;
            final Color logoColor = _logoColorAnimation.value ?? LightThemeColors.primary;

            return Scaffold(
              backgroundColor: backgroundColor,
              body: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedAlign(
                    duration: Duration.zero,
                    alignment: _alignmentAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Image.asset(
                        Assets.images.logo.path,
                        width: logoWidth,
                        fit: BoxFit.contain,
                        color: logoColor,
                        colorBlendMode: BlendMode.srcIn,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ],
              ).setContainerToView(),
            );
          },
        );
      },
    );
  }
}
