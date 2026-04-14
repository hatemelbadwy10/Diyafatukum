import '../../../../../../../core/resources/resources.dart';

import '../../../../../../../core/config/extensions/all_extensions.dart';
import 'package:flutter/material.dart';

import '../../../data/model/address_type_enum.dart';

class AddressTypesField extends StatefulWidget {
  const AddressTypesField({super.key, this.onChanged, this.initialValue});

  final AddressType? initialValue;
  final ValueChanged<AddressType>? onChanged;

  @override
  State<AddressTypesField> createState() => _AddressTypesFieldState();
}

class _AddressTypesFieldState extends State<AddressTypesField> {
  late final ValueNotifier<AddressType> typeNotifier;

  @override
  void initState() {
    typeNotifier = ValueNotifier(widget.initialValue ?? AddressType.home);
    typeNotifier.addListener(() => widget.onChanged?.call(typeNotifier.value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: typeNotifier,
      builder: (context, value, child) {
        return Row(
          spacing: 8,
          children: AddressType.values.map((type) {
            final isSelected = type == value;
            return Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                type.icon.svg(
                  width: 16,
                  colorFilter: (isSelected ? context.onPrimary : context.bodySmall.color!).colorFilter,
                ),
                Text(type.title, style: (isSelected ? context.labelSmall : context.bodySmall).regular.s12),
              ],
            )
                .setInkContainerToView(
                  padding: 8,
                  radius: AppSize.mainRadius,
                  color: isSelected ? context.primarySwatch[600]! : context.primaryCardColor,
                )
                .onTap(() => typeNotifier.value = type, borderRadius: AppSize.mainRadius.borderRadius);
          }).toList(),
        );
      },
    );
  }
}
