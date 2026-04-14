import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../../../../core/resources/resources.dart';

class CustomResponsiveBreakpoints extends StatelessWidget {
  const CustomResponsiveBreakpoints({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBreakpoints(
      breakpoints: const [
        Breakpoint(start: 0, end: AppSize.mobileBreakpoint, name: MOBILE),
        Breakpoint(start: AppSize.mobileBreakpoint + 1, end: AppSize.tabletBreakpoint, name: TABLET),
        Breakpoint(start: AppSize.tabletBreakpoint + 1, end: double.infinity, name: DESKTOP),
      ],
      child: Builder(builder: (context) {
        return ResponsiveScaledBox(
          width: ResponsiveValue<double?>(context, conditionalValues: [
            const Condition.equals(name: MOBILE, value: 430 * 1),
            const Condition.equals(name: TABLET, value: 850 * 1),
            const Condition.equals(name: DESKTOP, value: 1440 * 1),
          ]).value,
          child: child,
        );
      }),
    );
  }
}
