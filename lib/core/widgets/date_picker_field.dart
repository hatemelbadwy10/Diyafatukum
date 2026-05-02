import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'custom_text_field.dart';

class DatePickerField extends StatefulWidget {
  const DatePickerField({
    super.key,
    this.hint,
    this.title,
    this.initialValue,
    this.minDate,
    this.maxDate,
    this.onChanged,
    this.validator,
    this.isRequired = true,
  });

  final String? hint;
  final String? title;
  final DateTime? initialValue;
  final DateTime? minDate;
  final DateTime? maxDate;
  final void Function(DateTime)? onChanged;
  final String? Function(DateTime?)? validator;
  final bool isRequired;

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late final ValueNotifier<DateTime?> _date;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _date = ValueNotifier<DateTime?>(widget.initialValue);
    _controller.text = dateText ?? '';
    _date.addListener(() => _controller.text = dateText ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _date,
      builder: (context, dateTime, child) {
        return FormField<DateTime?>(
          validator:
              widget.validator ??
              (date) => Validator.validateRequired(
                date.toString(),
                isRequired: widget.isRequired,
                title: LocaleKeys.details_date_time_date.tr(),
              ),
          builder: (FormFieldState<DateTime?> formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  isRequired: widget.isRequired,
                  controller: _controller,
                  title: widget.title ?? LocaleKeys.details_date_time_date.tr(),
                  hint:
                      widget.hint ??
                      LocaleKeys.details_date_time_date.tr().selectHint,
                  readOnly: true,
                  prefixIcon: Assets.icons.calendar.path,
                  onTap: () async {
                    if (!context.isAndroid) {
                      _date.value =
                          await showDatePicker(
                            context: context,
                            initialDate: _initialPickerDate,
                            firstDate:
                                widget.minDate ??
                                DateTime.now().subtract(
                                  const Duration(days: 365 * 18),
                                ),
                            lastDate:
                                widget.maxDate ??
                                DateTime.now().add(
                                  const Duration(days: 365 * 18),
                                ),
                          ).then((value) {
                            if (value != null) {
                              formState.didChange(value);

                              _controller.text = dateText ?? '';
                              return value;
                            } else {
                              return _date.value;
                            }
                          });
                    } else {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          dateTime = _initialPickerDate;
                          return Container(
                            color: context.scaffoldBackgroundColor,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Material(
                                      color: context.scaffoldBackgroundColor,
                                      child: Text(LocaleKeys.actions_done.tr())
                                          .clickable(
                                            style: context.titleLarge.bold.s14,
                                            padding: 16.edgeInsetsAll.copyWith(
                                              bottom: 0,
                                            ),
                                            onTap: () {
                                              context.pop();
                                              _date.value = dateTime;
                                              _controller.text = dateText ?? '';
                                              widget.onChanged?.call(dateTime!);
                                              formState.didChange(dateTime);
                                            },
                                          ),
                                    ),
                                  ],
                                ),
                                CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  maximumDate: widget.maxDate,
                                  minimumDate: minimumDate,
                                  initialDateTime: _initialPickerDate,
                                  onDateTimeChanged: (value) =>
                                      dateTime = value,
                                ).withHeight(240),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    final selectedDate = _date.value;
                    if (selectedDate != null) {
                      widget.onChanged?.call(selectedDate);
                    }
                  },
                ),
                if (formState.hasError)
                  Text(
                    formState.errorText!,
                    style: context.errorStyle,
                  ).paddingTop(8),
              ],
            );
          },
        );
      },
    );
  }

  TextStyle? get dateStyle {
    if (_date.value == null) {
      return context.hintTextStyle;
    } else {
      return context.textTheme.bodyLarge?.regular.s12;
    }
  }

  String? get dateText => _date.value?.format();

  DateTime? get minimumDate {
    if (widget.initialValue != null &&
        widget.minDate != null &&
        widget.initialValue!.isBefore(widget.minDate!)) {
      return widget.initialValue;
    }
    return widget.minDate ??
        DateTime.now().subtract(const Duration(days: 365 * 18));
  }

  DateTime get maximumDate =>
      widget.maxDate ?? DateTime.now().add(const Duration(days: 365 * 18));

  DateTime get _initialPickerDate {
    final initialDate = _date.value ?? DateTime.now().startOfDay;
    final minDate = minimumDate;
    if (minDate != null && initialDate.isBefore(minDate)) {
      return minDate;
    }
    final maxDate = maximumDate;
    if (initialDate.isAfter(maxDate)) {
      return maxDate;
    }
    return initialDate;
  }
}
