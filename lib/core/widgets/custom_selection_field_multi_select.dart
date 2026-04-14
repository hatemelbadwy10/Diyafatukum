import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'custom_loading.dart';
import 'custom_text_field.dart';
import 'vertical_list_view.dart';

class CustomSelectionFieldMultiSelect<T> extends StatefulWidget {
  const CustomSelectionFieldMultiSelect({
    super.key,
    this.title,
    this.hint,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.futureRequest,
    this.itemBuilder,
    this.itemToString,
    this.initialValues,
  });

  final String? title;
  final String? hint;
  final String? prefixIcon;
  final void Function(List<T>?)? onChanged;
  final String? Function(List<T>?)? validator;
  final FutureOr<List<T>> Function()? futureRequest;
  final Widget Function(BuildContext, int)? itemBuilder;
  final String Function(T?)? itemToString;
  final List<T>? initialValues;

  static void show<T>({
    required BuildContext context,
    String? title,
    String? hint,
    String? prefixIcon,
    void Function(List<T>?)? onChanged,
    String? Function(List<T>?)? validator,
    FutureOr<List<T>> Function()? futureRequest,
    Widget Function(BuildContext, int)? itemBuilder,
    String Function(T?)? itemToString,
    List<T>? initialValues,
  }) {
    final ValueNotifier<List<T>> selectedValues = ValueNotifier<List<T>>(initialValues ?? []);

    context.showScrollableBottomSheet(
      title: Text(hint ?? title ?? '', style: context.bodyLarge.bold),
      body: FutureBuilder<List<T>>(
        future: Future.value(futureRequest?.call()),
        builder: (context, snapshot) {
          final List<T> data = snapshot.data ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoading().withHeight(200);
          }
          if (data.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.error_no_results.tr(),
                style: context.bodySmall.regular.s12,
              ).center().withHeight(200),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 500,
                child: ValueListenableBuilder<List<T>>(
                  valueListenable: selectedValues,
                  builder: (context, selectedItems, child) {
                    return VerticalListView(
                      enableScroll: true,
                      padding: 0.edgeInsetsAll,
                      separator: Divider(height: 0, indent: AppSize.screenPadding),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        final isSelected = selectedItems.contains(item);

                        return IgnorePointer(
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSelected,
                                onChanged: (checked) {
                                  if (checked == true) {
                                    selectedValues.value = [...selectedItems, item];
                                  } else {
                                    selectedValues.value = selectedItems.where((e) => e != item).toList();
                                  }
                                },
                              ),
                              Text(itemToString?.call(item) ?? '', style: context.bodyLarge.s12),
                            ],
                          ).paddingSymmetric(AppSize.screenPadding, 8),
                        ).onTap(() {
                          final checked = !isSelected;
                          if (checked == true) {
                            selectedValues.value = [...selectedItems, item];
                          } else {
                            selectedValues.value = selectedItems.where((e) => e != item).toList();
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  onChanged?.call(selectedValues.value);
                },
                child: Text(LocaleKeys.actions_save.tr()),
              ).paddingBottom(16).paddingHorizontal(16),
            ],
          );
        },
      ),
    );
  }

  @override
  State<CustomSelectionFieldMultiSelect<T>> createState() => _CustomSelectionFieldMultiSelectState<T>();
}

class _CustomSelectionFieldMultiSelectState<T> extends State<CustomSelectionFieldMultiSelect<T>> {
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
        CustomSelectionFieldMultiSelect.show(
          context: context,
          title: widget.title,
          hint: widget.hint,
          prefixIcon: widget.prefixIcon,
          onChanged: (selected) {
            _selectedValues.value = selected ?? [];
            controller.text = _selectedValues.value.map((e) => widget.itemToString?.call(e) ?? '').join(', ');
            widget.onChanged?.call(selected);
          },
          futureRequest: widget.futureRequest,
          itemToString: widget.itemToString,
          initialValues: _selectedValues.value,
        );
      },
    );
  }
}
