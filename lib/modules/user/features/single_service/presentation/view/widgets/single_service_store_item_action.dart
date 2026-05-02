import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import '../../../../../../../core/resources/gen/locale_keys.g.dart';

class SingleServiceStoreItemAction extends StatelessWidget {
  const SingleServiceStoreItemAction({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.isAvailable,
    required this.onSelect,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final int maxQuantity;
  final bool isAvailable;
  final VoidCallback onSelect;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final canIncrement = isAvailable && quantity < maxQuantity;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: quantity == 0
          ? Text(
                  isAvailable
                      ? LocaleKeys.home_user_store_choose.tr()
                      : LocaleKeys.error_not_available.tr(),
                  key: const ValueKey('select_button'),
                  style: context.bodyMedium.medium.s14.setColor(
                    isAvailable
                        ? context.bodyMedium.color!
                        : context.greySwatch.shade500,
                  ),
                )
                .center()
                .setContainerToView(
                  width: 72,
                  height: 40,
                  radius: 12,
                  color: context.scaffoldBackgroundColor,
                  borderColor: context.greySwatch.shade300,
                )
                .onTap(
                  isAvailable ? onSelect : null,
                  borderRadius: 12.borderRadius,
                )
          : Row(
              key: ValueKey('counter_$quantity'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '−',
                  style: context.displayMedium.medium.s24.setColor(
                    context.greySwatch.shade500,
                  ),
                ).onTap(onDecrement, borderRadius: 16.borderRadius),
                10.gap,
                Text(
                  '$quantity',
                  style: context.titleMedium.medium.s18,
                ).center().setContainerToView(
                  width: 40,
                  height: 40,
                  radius: 20,
                  color: context.scaffoldBackgroundColor,
                  borderColor: context.greySwatch.shade200,
                ),
                10.gap,
                Text(
                  '+',
                  style: context.displayMedium.medium.s24.setColor(
                    canIncrement
                        ? context.primaryColor
                        : context.greySwatch.shade400,
                  ),
                ).onTap(
                  canIncrement ? onIncrement : null,
                  borderRadius: 16.borderRadius,
                ),
              ],
            ),
    );
  }
}
