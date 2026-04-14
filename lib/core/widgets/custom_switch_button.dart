import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';

class CustomSwitchButton extends StatefulWidget {
  const CustomSwitchButton({super.key, this.onChanged, this.enable = true, this.value = false});

  final ValueChanged<bool>? onChanged;
  final bool enable;
  final bool value;

  @override
  State<CustomSwitchButton> createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  final ValueNotifier<bool> _value = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _value.value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _value,
      builder: (context, value, _) {
        return SizedBox(
          width: 40,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Switch.adaptive(
              value: value,
              padding: EdgeInsets.zero,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: context.disabledButtonColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              thumbColor: const WidgetStatePropertyAll(Colors.white),
              trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
              onChanged: widget.enable
                  ? (value) {
                      _value.value = value;
                      widget.onChanged?.call(value);
                    }
                  : null,
            ).withHeight(40),
          ),
        );
      },
    );
  }
}
