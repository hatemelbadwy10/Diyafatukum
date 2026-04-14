import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';

class CustomSliderBar extends StatefulWidget {
  const CustomSliderBar({
    super.key,
    this.onUpperValueChanged,
    this.onLowerValueChanged,
    this.initialLowerValue,
    this.initialUpperValue,
  });

  final ValueChanged<double>? onUpperValueChanged;
  final ValueChanged<double>? onLowerValueChanged;
  final double? initialLowerValue;
  final double? initialUpperValue;

  @override
  State<CustomSliderBar> createState() => _CustomSliderBarState();
}

class _CustomSliderBarState extends State<CustomSliderBar> {
  late final ValueNotifier<double> _lowerValue;
  late final ValueNotifier<double> _upperValue;

  @override
  void initState() {
    _lowerValue = ValueNotifier(widget.initialLowerValue ?? 0);
    _upperValue = ValueNotifier(widget.initialUpperValue ?? 5000);

    _lowerValue.addListener(() => widget.onLowerValueChanged?.call(_lowerValue.value));
    _upperValue.addListener(() => widget.onUpperValueChanged?.call(_upperValue.value));
    super.initState();
  }

  @override
  void dispose() {
    _lowerValue.dispose();
    _upperValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double max = 5000;
    const double min = 0;
    return ValueListenableBuilder(
      valueListenable: _lowerValue,
      builder: (context, value, child) {
        return Column(
          children: [
            FlutterSlider(
              rtl: context.isRTL,
              values: [_lowerValue.value, _upperValue.value],
              rangeSlider: true,
              max: max,
              min: min,
              jump: true,
              tooltip: FlutterSliderTooltip(
                alwaysShowTooltip: true,
                textStyle: context.labelSmall.s12.regular,
                leftSuffix: Text(' ${LocaleKeys.currency_sar.tr()}', style: context.labelSmall.s12.regular),
                rightSuffix: Text(' ${LocaleKeys.currency_sar.tr()}', style: context.labelSmall.s12.regular),
                positionOffset: FlutterSliderTooltipPositionOffset(top: -12),
                format: (value) => value.toDouble().toStringAsFixed(0),
                boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(color: context.primaryColor, borderRadius: BorderRadius.circular(8)),
                ),
              ),
              trackBar: FlutterSliderTrackBar(
                activeTrackBar: BoxDecoration(color: context.primaryColor),
                inactiveTrackBar: BoxDecoration(color: context.iconInactiveColor),
                activeTrackBarHeight: 2,
                inactiveTrackBarHeight: 2,
              ),
              handlerHeight: 20,
              handlerWidth: 20,
              decoration: BoxDecoration(
                color: context.scaffoldBackgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
              handler: FlutterSliderHandler(
                child: const SizedBox.shrink(),
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.primaryColor),
                ),
              ),
              rightHandler: FlutterSliderHandler(
                child: const SizedBox.shrink(),
                decoration: BoxDecoration(
                  color: context.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.primaryColor),
                ),
              ),
              onDragging: (handlerIndex, lowerValue, upperValue) {
                _lowerValue.value = lowerValue;
                _upperValue.value = upperValue;
              },
            ).withHeight(70),
          ],
        ).setTitle(title: LocaleKeys.sort_price_title.tr(), gap: 16);
      },
    );
  }
}
