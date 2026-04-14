import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import 'horizontal_list_view.dart';

class CustomSelectableList<T> extends StatefulWidget {
  const CustomSelectableList({
    super.key,
    this.title,
    this.itemToString,
    required this.items,
    this.onSelected,
    this.initialValue,
  });

  final T? initialValue;
  final List<T> items;
  final String Function(T)? itemToString;
  final String? title;
  final ValueChanged<T>? onSelected;

  @override
  State<CustomSelectableList<T>> createState() => _CustomSelectableListState<T>();
}

class _CustomSelectableListState<T> extends State<CustomSelectableList<T>> {
  late ValueNotifier<int?> selectedIndex;

  @override
  void initState() {
    selectedIndex = ValueNotifier(widget.initialValue != null ? widget.items.indexOf(widget.initialValue as T) : null);
    super.initState();
  }

  void _onSelected(int index) {
    selectedIndex.value = index;
    widget.onSelected?.call(widget.items[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: selectedIndex,
      builder: (_, index, _) {
        return HorizontalListView(
          height: 32,
          separatorWidth: 8,
          title: widget.title,
          titleStyle: context.bodyLarge.s12.semiBold,
          itemCount: widget.items.length,
          itemBuilder: (_, index) {
            final isSelected = index == selectedIndex.value;
            final textColor = isSelected ? context.onPrimary : null;
            final bgColor = isSelected ? context.primaryColor : null;
            final borderColor = isSelected ? context.primaryColor : context.variantBorderColor;
            return Text(
                  widget.itemToString?.call(widget.items[index]) ?? widget.items[index].toString(),
                  style: context.bodyLarge.regular.s14.copyWith(color: textColor),
                )
                .center()
                .paddingHorizontal(20)
                .setContainerToView(radius: 4, color: bgColor, borderColor: borderColor)
                .onTap(() => _onSelected(index), borderRadius: 4.0.borderRadius);
          },
        );
      },
    );
  }
}
