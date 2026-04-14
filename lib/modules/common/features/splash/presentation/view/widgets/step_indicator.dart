import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../data/model/onboarding_steps_enum.dart';
import '../../../../../../../core/resources/resources.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(OnboardingSteps.values.length, (index) {
        final bool isCurrent = index == currentIndex;
        return Container(
          width: isCurrent ? 10 : 6,
          height: isCurrent ? 10 : 6,
          margin: 4.edgeInsetsAll,
          decoration: BoxDecoration(
            gradient: isCurrent ? GradientStyles.primaryGradient : null,
            color: isCurrent ? context.primaryColor : context.disabledButtonColor,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
