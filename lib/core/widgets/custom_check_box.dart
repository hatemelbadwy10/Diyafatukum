import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    super.key,
    this.initialValue = false,
    this.isRequired = false,
    required this.label,
    this.onChanged,
  });

  final bool initialValue;
  final Widget label;
  final bool isRequired;
  final ValueChanged<bool>? onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late final ValueNotifier<bool> _checkValueNotifier;
  @override
  void initState() {
    _checkValueNotifier = ValueNotifier(widget.initialValue);
    _checkValueNotifier.addListener(() => widget.onChanged?.call(_checkValueNotifier.value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _checkValueNotifier,
      builder: (context, checked, child) {
        return FormField(
          validator: (value) => widget.isRequired && !_checkValueNotifier.value ? 'required' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<bool> formState) {
            return Row(
              children: [
                Checkbox.adaptive(
                  value: checked,
                  activeColor: context.primaryColor,
                  isError: formState.hasError,
                  checkColor: context.onPrimary,
                  shape: RoundedRectangleBorder(borderRadius: 4.borderRadius),
                  side: BorderSide(width: 1, color: _getBorderColor(checked, formState.hasError, context)),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onChanged: (value) {
                    _checkValueNotifier.value = value!;
                    formState.didChange(value);
                  },
                ).withSize(24, 24),
                8.gap,
                widget.label,
              ],
            );
          },
        );
      },
    );
  }

  Color _getBorderColor(bool checked, bool hasError, BuildContext context) {
    if (hasError) {
      return context.errorColor;
    } else if (checked) {
      return context.primaryColor;
    } else {
      return context.inputFieldBorderColor;
    }
  }
}
