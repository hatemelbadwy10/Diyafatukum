import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import 'custom_loading.dart';
import 'custom_text_field.dart';
import 'vertical_list_view.dart';

class CustomSelectionField<T> extends StatefulWidget {
  const CustomSelectionField({
    super.key,
    this.title,
    this.hint,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.futureRequest,
    this.itemBuilder,
    this.itemToString,
    this.initialValue,
    this.prefixWidget,
    this.height,
    this.textAlign = TextAlign.start,
    this.separator,
  });
  final String? title;
  final String? hint;
  final String? prefixIcon;
  final Widget? prefixWidget;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final FutureOr<List<T>> Function()? futureRequest;
  final Widget Function(BuildContext, T)? itemBuilder;
  final String Function(T?)? itemToString;
  final T? initialValue;
  final TextAlign textAlign;
  final double? height;
  final Widget? separator;

  @override
  State<CustomSelectionField<T>> createState() => _CustomSelectionFieldState<T>();
}

class _CustomSelectionFieldState<T> extends State<CustomSelectionField<T>> {
  late TextEditingController controller;
  late ValueNotifier<T?> _value;

  @override
  void initState() {
    _value = ValueNotifier<T?>(widget.initialValue);
    controller = TextEditingController(text: widget.itemToString?.call(widget.initialValue) ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _value.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      readOnly: true,
      hint: widget.hint,
      title: widget.title,
      textAlign: widget.textAlign,
      controller: controller,
      height: widget.height,
      prefixIcon: widget.prefixIcon,
      prefix: widget.prefixWidget,
      validator: (_) => widget.validator?.call(_value.value),
      suffix: Assets.icons.dropdownArrow.svg(colorFilter: context.hintColor.colorFilter).center().withSize(20, 20),
      onTap: () async {
        context.showScrollableBottomSheet(
          title: Text(widget.hint ?? widget.title ?? '', style: context.bodyLarge.bold),
          body: FutureBuilder<List<T>>(
            future: Future.value(widget.futureRequest?.call()),
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
              return VerticalListView(
                enableScroll: false,
                padding: 0.edgeInsetsAll,
                separator: widget.separator ?? Divider(height: 0, indent: AppSize.screenPadding),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Row(
                    children: [
                      if (widget.itemBuilder != null)
                        widget.itemBuilder!.call(context, item).expand()
                      else
                        Text(widget.itemToString?.call(item) ?? '', style: context.bodyLarge.s14),
                      const Spacer(),
                      if (_value.value == item)
                        Assets.icons.done.svg(
                          height: AppSize.iconMedium,
                          colorFilter: context.primaryColor.colorFilter,
                        ),
                    ],
                  ).paddingSymmetric(AppSize.screenPadding, 12).onTap(() {
                    if (item.runtimeType == T) widget.onChanged?.call(item);
                    _value.value = item;
                    controller.text = widget.itemToString?.call(item) ?? '';
                    context.pop();
                  });
                },
              ).paddingBottom(16);
            },
          ),
        );
      },
    );
  }
}
