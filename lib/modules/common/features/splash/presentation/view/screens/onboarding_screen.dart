import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/theme/light_theme.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../common/features/shared/data/model/navigation_bar_items.dart';
import '../../../presentation/controller/splash_cubit.dart';
import '../widgets/language_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String _backgroundImage = 'assets/images/welcome_screen.png';

  void _markAsViewed(BuildContext context) {
    context.read<SplashCubit>().saveOnboardingStatus(true);
  }

  void _goToLogin(BuildContext context) {
    _markAsViewed(context);
    AppRoutes.login.go();
  }

  void _goToRegister(BuildContext context) {
    _markAsViewed(context);
    AppRoutes.register.go();
  }

  void _continueAsGuest(BuildContext context) {
    _markAsViewed(context);
    bottomNavNotifier.value = NavigationBarItems.home;
    AppRoutes.home.go();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_backgroundImage, fit: BoxFit.fill),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.18),
                  Colors.black.withValues(alpha: 0.36),
                  Colors.black.withValues(alpha: 0.78),
                  Colors.black.withValues(alpha: 0.92),
                ],
                stops: const [0.0, 0.35, 0.72, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                AppSize.screenPadding,
                12,
                AppSize.screenPadding,
                24 + context.navigationBarHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: LanguageButton(),
                  ),
                  const Spacer(),
                  _WelcomeCopy(
                    titlePrefix: LocaleKeys.onboarding_welcome_brand.tr(),
                    titleSuffix: LocaleKeys.onboarding_welcome_title.tr(),
                    subtitle: LocaleKeys.onboarding_welcome_subtitle.tr(),
                  ),
                  28.gap,
                  CustomButton(
                    label: LocaleKeys.auth_login_title.tr(),
                    onPressed: () => _goToLogin(context),
                    height: 68,
                    shape: ButtonShape.rounded,
                    borderRadius: 22,
                    backgroundColor: LightThemeColors.primary,
                    fontColor: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                  16.gap,
                  CustomButton.outlined(
                    label: LocaleKeys.auth_register_title.tr(),
                    onPressed: () => _goToRegister(context),
                    height: 68,
                    shape: ButtonShape.rounded,
                    borderRadius: 22,
                    borderColor: Colors.white.withValues(alpha: 0.22),
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    fontColor: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                  24.gap,
                  TextButton(
                    onPressed: () => _continueAsGuest(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys.onboarding_welcome_guest_prefix.tr(),
                            style: context.titleLarge.regular.s16.copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: LocaleKeys.onboarding_welcome_guest_action.tr(),
                            style: context.titleLarge.bold.s16.copyWith(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeCopy extends StatelessWidget {
  const _WelcomeCopy({
    required this.titlePrefix,
    required this.titleSuffix,
    required this.subtitle,
  });

  final String titlePrefix;
  final String titleSuffix;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$titlePrefix ',
                style: context.displaySmall.bold.setFontSize(24).copyWith(
                  color: LightThemeColors.primary,
                  height: 1.25,
                ),
              ),
              TextSpan(
                text: titleSuffix,
                style: context.displaySmall.bold.setFontSize(24).copyWith(
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        18.gap,
        Text(
          subtitle,
          textAlign: TextAlign.start,
          style: context.titleLarge.regular.s14.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
            height: 1.7,
          ),
        ),
      ],
    );
  }
}
