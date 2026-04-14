import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import 'custom_loading.dart';

class CustomSwitchField extends StatefulWidget {
  const CustomSwitchField({
    super.key,
    this.titleText,
    required this.value,
    this.onChanged,
    this.isLoading = false,
    this.title,
    this.enable = true,
  });

  final String? titleText;
  final Widget? title;
  final bool value;
  final void Function(bool)? onChanged;
  final bool isLoading;
  final bool enable;

  @override
  State<CustomSwitchField> createState() => _CustomSwitchFieldState();
}

class _CustomSwitchFieldState extends State<CustomSwitchField> {
  late final ValueNotifier<bool> _value;
  @override
  void initState() {
    _value = ValueNotifier<bool>(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        (widget.title ?? Text(widget.titleText ?? "", style: context.bodyLarge.regular.s12)).flexible(),
        if (widget.isLoading)
          const CustomLoading().setContainerToView(height: 50)
        else
          ValueListenableBuilder<bool>(
            valueListenable: _value,
            builder: (context, value, _) {
              return Switch.adaptive(
                value: value,
                inactiveThumbColor: Colors.white,
                trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                inactiveTrackColor: context.disabledButtonColor,
                thumbColor: const WidgetStatePropertyAll(Colors.white),
                onChanged: widget.enable
                    ? (value) {
                        _value.value = value;
                        widget.onChanged?.call(value);
                      }
                    : null,
              );
            },
          ),
      ],
    ).paddingHorizontal(8);
  }
}
