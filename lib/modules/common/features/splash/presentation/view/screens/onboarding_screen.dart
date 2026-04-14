import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/config/router/app_route.dart';
import '../../../../../../../core/config/theme/light_theme.dart';
import '../../../../../../../core/resources/resources.dart';
import '../../../../../../../core/widgets/buttons/custom_buttons.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../../core/widgets/custom_arrow.dart';
import '../../../data/model/onboarding_steps_enum.dart';
import '../../controller/splash_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  void _onPageChanged(int index) {
    _pageController.animateToPage(index, duration: 500.milliseconds, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        final cubit = context.watch<SplashCubit>();
        return Scaffold(
          appBar: CustomAppBar.build(
            actions: [
              CustomTextButton(
                label: "${LocaleKeys.actions_skip.tr()}>>",
                onPressed: () {
                  AppRoutes.login.go();
                  cubit.saveOnboardingStatus(true);
                },
              ).paddingEnd(16),
            ],
          ),
          body: PageView.builder(
            controller: _pageController,
            physics: const ClampingScrollPhysics(),
            itemCount: OnboardingSteps.values.length,
            itemBuilder: (context, index) {
              final step = OnboardingSteps.values[index];
              return Column(
                children: [
                  24.gap,
                  Text(
                    step.title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: context.displayLarge.medium.s20.setColor(LightThemeColors.tertiary[900]!),
                  ).fit().paddingHorizontal(AppSize.screenPadding),
                  step.image.image(fit: BoxFit.contain, width: context.width),
                  16.gap,
                  Text(
                    step.subtitle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: context.titleLarge.regular.s16,
                  ).fit().paddingHorizontal(AppSize.screenPadding),
                  8.gap,
                  Text(step.hint, textAlign: TextAlign.center, style: context.bodyLarge.s14.regular).withWidth(320),
                  24.gap,
                  Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (index != 0) CustomArrow.back(onTap: () => _onPageChanged(index - 1), enabled: index != 0),
                      if (index != OnboardingSteps.values.length - 1)
                        CustomArrow.next(
                          onTap: () => _onPageChanged(index + 1),
                          enabled: index != OnboardingSteps.values.length - 1,
                        ),
                    ],
                  ),
                  24.gap,
                  if (index == OnboardingSteps.values.length - 1)
                    CustomButton.gradient(
                      width: 100,
                      label: LocaleKeys.onboarding_action.tr(),
                      onPressed: () {
                        AppRoutes.login.go();
                        cubit.saveOnboardingStatus(true);
                      },
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
