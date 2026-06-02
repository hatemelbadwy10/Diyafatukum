import 'package:diyafatukum/core/widgets/custom_arrow_back.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/resources.dart';

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
  static const double _sheetRadius = 36;
  static const double _minImageVisibleRatio = 0.28;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double minImageHeight =
              constraints.maxHeight * _minImageVisibleRatio;
          return Stack(
            children: [
              Positioned.fill(
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
                            context.tertiarySwatch.shade900
                                .withValues(alpha: 0.08),
                            context.tertiarySwatch.shade900
                                .withValues(alpha: 0.42),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight - minImageHeight,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(_sheetRadius),
                      ),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _AuthHeader(
                            title: title,
                            onBackPressed: onBackPressed,
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.screenPadding,
                              ).copyWith(top: 8, bottom: 16),
                              child: child,
                            ),
                          ),
                          if (bottom != null)
                            bottom!
                                .paddingHorizontal(AppSize.screenPadding)
                                .paddingVertical(16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
            alignment: context.isRTL
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: CustomArrowBack(
              onPressed: onBackPressed,
            ),
          ),
        ],
      ).paddingHorizontal(AppSize.screenPadding),
    );
  }
}
