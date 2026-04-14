import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../core/resources/resources.dart';

enum OnboardingSteps {
  step1,
  step2,
  step3;

  String get title {
    switch (this) {
      case OnboardingSteps.step1:
        return LocaleKeys.onboarding_titles_first.tr();
      case OnboardingSteps.step2:
        return LocaleKeys.onboarding_titles_second.tr();
      case OnboardingSteps.step3:
        return LocaleKeys.onboarding_titles_third.tr();
    }
  }

  String get subtitle {
    switch (this) {
      case OnboardingSteps.step1:
        return LocaleKeys.onboarding_subtitles_first.tr();
      case OnboardingSteps.step2:
        return LocaleKeys.onboarding_subtitles_second.tr();
      case OnboardingSteps.step3:
        return LocaleKeys.onboarding_subtitles_third.tr();
    }
  }

  String get hint {
    switch (this) {
      case OnboardingSteps.step1:
        return LocaleKeys.onboarding_hints_first.tr();
      case OnboardingSteps.step2:
        return LocaleKeys.onboarding_hints_second.tr();
      case OnboardingSteps.step3:
        return LocaleKeys.onboarding_hints_third.tr();
    }
  }

  AssetGenImage get image {
    switch (this) {
      case OnboardingSteps.step1:
        return Assets.images.onboardingStepOne;
      case OnboardingSteps.step2:
        return Assets.images.onboardingStepTwo;
      case OnboardingSteps.step3:
        return Assets.images.onboardingStepThree;
    }
  }
}
