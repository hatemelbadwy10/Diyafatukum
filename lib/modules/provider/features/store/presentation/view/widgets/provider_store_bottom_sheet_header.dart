import 'package:flutter/material.dart';

import '../../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../../core/config/router/route_manager.dart';
import '../../../../../../../../core/resources/resources.dart';

class ProviderStoreBottomSheetHeader extends StatelessWidget {
  const ProviderStoreBottomSheetHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        36.gap,
        Text(
          title,
          style: context.displaySmall.bold.s24,
          textAlign: TextAlign.center,
        ).expand(),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.greySwatch.shade50,
            shape: BoxShape.circle,
          ),
          child: Assets.icons.arrowRightAlt
              .svg(
                width: 16,
                height: 16,
                colorFilter: context.greySwatch.shade600.colorFilter,
              )
              .center()
              .onTap(BaseRouter.pop, borderRadius: 18.borderRadius),
        ),
      ],
    );
  }
}
