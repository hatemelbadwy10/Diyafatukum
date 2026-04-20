import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/debouncer.dart';
import 'custom_input_field.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.onChanged,
    this.hintText,
    this.onFilter,
    this.onTap,
    this.readOnly = false,
    this.autoFocus = false,
  });

  final bool readOnly;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final String? hintText;
  final void Function()? onFilter;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return CustomInputField.filled(
      height: 42,
      onTap: onTap,
      readOnly: readOnly,
      autoFocus: autoFocus,
      borderColor: context.inputFieldBorderColor,
      hint: hintText ?? '${LocaleKeys.search_title.tr()}...',
      prefixIcon: Assets.icons.search.path.toSvg(color: context.hintColor).paddingAll(4),
      onChanged: (query) => Debouncer.instance.run(() => onChanged?.call(query)),
    );
  }
}
