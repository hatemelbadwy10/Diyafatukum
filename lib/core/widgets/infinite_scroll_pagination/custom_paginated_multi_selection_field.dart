import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config/extensions/all_extensions.dart';
import '../../resources/resources.dart';
import '../../utils/toaster_utils.dart';
import '../buttons/custom_button.dart';
import '../custom_fallback_view.dart';
import '../custom_text_field.dart';
import 'paginated_list_view.dart';

class CustomPaginatedSelectionField<P, T> extends StatefulWidget {
  final double? separatorIndent;
  final String? title;
  final String? hint;
  final String? prefixIcon;
  final void Function(List<T>?)? onChanged;
  final String? Function(List<T>?)? validator;
  final PagingController<P, T> pageController;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String Function(T?)? itemToString;
  final List<T>? initialValues;
  final bool isMultiSelection;

  const CustomPaginatedSelectionField({
    super.key,
    this.title,
    this.hint,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.itemBuilder,
    this.itemToString,
    this.initialValues,
    this.separatorIndent,
    this.isMultiSelection = true,
    required this.pageController,
  });

  factory CustomPaginatedSelectionField.single({
    String? title,
    String? hint,
    String? prefixIcon,
    void Function(T?)? onChanged,
    String? Function(T?)? validator,
    Widget Function(BuildContext, T)? itemBuilder,
    String Function(T?)? itemToString,
    T? initialValue,
    double? separatorIndent,
    bool isMultiSelection = false,
    required PagingController<P, T> pageController,
  }) {
    return CustomPaginatedSelectionField<P, T>(
      title: title,
      hint: hint,
      prefixIcon: prefixIcon,
      onChanged: (items) => onChanged?.call(items?.first),
      validator: (items) => validator?.call(items?.first),
      itemBuilder: itemBuilder,
      itemToString: itemToString,
      initialValues: initialValue == null ? null : [initialValue],
      separatorIndent: separatorIndent,
      isMultiSelection: false,
      pageController: pageController,
    );
  }

  static void show<P, T>({
    required BuildContext context,
    String? title,
    String? hint,
    String? prefixIcon,
    void Function(List<T>?)? onChanged,
    String? Function(List<T>?)? validator,
    Widget Function(BuildContext, T)? itemBuilder,
    String Function(T?)? itemToString,
    List<T>? initialValues,
    double? separatorIndent,
    bool isMultiSelection = true,
    required PagingController<P, T> pageController,
  }) {
    final ValueNotifier<List<T>> selectedValues = ValueNotifier<List<T>>(initialValues ?? []);

    context.showScrollableBottomSheet(
      title: Text(hint ?? title ?? '', style: context.bodyLarge.bold),
      bottom: CustomButton(
        onPressed: () {
          context.pop();
          onChanged?.call(selectedValues.value);
        },
        label: LocaleKeys.actions_done.tr(),
      ).paddingBottom(8),
      body: Column(
        children: [
          ValueListenableBuilder<List<T>>(
            valueListenable: selectedValues,
            builder: (context, selectedItems, child) {
              return PaginatedListView<P, T>(
                padding: 0.edgeInsetsAll,
                controller: pageController,
                separator: Divider(height: 0, indent: separatorIndent ?? AppSize.screenPadding),
                emptyItemBuilder: (context) => CustomFallbackView(
                  icon: Icon(
                    CupertinoIcons.square_grid_2x2,
                    size: 72,
                    color: context.hintColor,
                  ).paddingTop(context.height / 4),
                  title: '',
                ),
                itemBuilder: (context, T item, index) {
                  final isSelected = selectedItems.contains(item);
                  return IgnorePointer(
                    child: Row(
                      children: [
                        if (itemBuilder != null)
                          itemBuilder.call(context, item).expand()
                        else
                          Text(itemToString?.call(item) ?? '', style: context.bodyLarge.s14),
                        const Spacer(),
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            shape: isMultiSelection ? BoxShape.rectangle : BoxShape.circle,
                            color: isSelected ? context.primaryColor : null,
                            borderRadius: isMultiSelection ? BorderRadius.circular(4) : null,
                            border: isSelected ? null : Border.all(color: context.inputFieldBorderColor),
                          ),
                          child: Assets.icons.done.svg(height: AppSize.iconMedium).visible(isSelected),
                        ),
                      ],
                    ).paddingSymmetric(AppSize.screenPadding, 8),
                  ).onTap(() {
                    if (isMultiSelection == false) {
                      selectedValues.value = [item];
                    } else {
                      final checked = !isSelected;
                      if (checked == true) {
                        selectedValues.value = [...selectedItems, item];
                      } else {
                        selectedValues.value = selectedItems.where((e) => e != item).toList();
                      }
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  State<CustomPaginatedSelectionField<P, T>> createState() => _CustomPaginatedSelectionFieldState<P, T>();
}

class _CustomPaginatedSelectionFieldState<P, T> extends State<CustomPaginatedSelectionField<P, T>> {
  late TextEditingController controller;
  late ValueNotifier<List<T>> _selectedValues;

  @override
  void initState() {
    _selectedValues = ValueNotifier<List<T>>(widget.initialValues ?? []);
    controller = TextEditingController(
      text: _selectedValues.value.map((e) => widget.itemToString?.call(e) ?? '').join(', '),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      readOnly: true,
      hint: widget.hint,
      title: widget.title,
      controller: controller,
      prefixIcon: widget.prefixIcon,
      validator: (_) => widget.validator?.call(_selectedValues.value),
      suffix: Assets.icons.dropdownArrow.svg(colorFilter: context.hintColor.colorFilter).center().withSize(20, 20),
      onTap: () async {
        final String? error = widget.validator?.call(_selectedValues.value.isEmpty ? null : _selectedValues.value);
        if (error != null) {
          Toaster.showToast(error);
          return;
        } else {
          CustomPaginatedSelectionField.show(
            context: context,
            title: widget.title,
            hint: widget.hint,
            prefixIcon: widget.prefixIcon,
            validator: widget.validator,
            separatorIndent: widget.separatorIndent,
            itemBuilder: widget.itemBuilder,
            itemToString: widget.itemToString,
            initialValues: _selectedValues.value,
            pageController: widget.pageController,
            isMultiSelection: widget.isMultiSelection,
            onChanged: (selected) {
              _selectedValues.value = selected ?? [];
              controller.text = _selectedValues.value.map((e) => widget.itemToString?.call(e) ?? '').join(', ');
              widget.onChanged?.call(selected);
            },
          );
        }
      },
    );
  }
}
