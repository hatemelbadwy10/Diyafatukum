import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';

class AuthBackgroundScaffold extends StatelessWidget {
  const AuthBackgroundScaffold({
    super.key,
    required this.title,
    required this.child,
    this.bottom,
    this.onBackPressed,
  });

  final String title;
  final Widget child;
  final Widget? bottom;
  final void Function()? onBackPressed;

  static const String _backgroundImage = 'assets/images/welcome_screen.png';

  @override
  Widget build(BuildContext context) {
    final double imageHeight = context.height * 0.42;
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(_backgroundImage, fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        context.tertiarySwatch.shade900.withValues(alpha: 0.08),
                        context.tertiarySwatch.shade900.withValues(alpha: 0.42),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: imageHeight - context.statusBarHeight - 24),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
                      boxShadow: [
                        BoxShadow(
                          color: context.greySwatch.shade900.withValues(alpha: 0.08),
                          blurRadius: 28,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _AuthHeader(title: title, onBackPressed: onBackPressed),
                        Expanded(child: child),
                        if (bottom != null)
                          bottom!
                              .paddingHorizontal(AppSize.screenPadding)
                              .paddingBottom(context.keyboardPadding)
                              .withSafeArea(minimum: 16.edgeInsetsVertical),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthHeader extends StatelessWidget {
  const _AuthHeader({required this.title, this.onBackPressed});

  final String title;
  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: context.displaySmall.semiBold.s22),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CustomIconButton.svg(
              svg: Assets.icons.arrowLeftAlt,
              onPressed: onBackPressed ?? () => context.pop(context),
              matchTextDirection: true,
              backgroundColor: context.greySwatch.shade50.withValues(alpha: 0.92),
              foregroundColor: context.titleMedium.color,
              size: 18,
              padding: 10.edgeInsetsAll,
              borderRadius: 18,
            ),
          ),
        ],
      ).paddingHorizontal(AppSize.screenPadding),
    );
  }
}
