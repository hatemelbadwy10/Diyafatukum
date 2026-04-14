import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'custom_text_field.dart';

class TimePickerField extends StatefulWidget {
  const TimePickerField({
    super.key,
    this.hint,
    this.title,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.validator,
    this.isRequired = true,
  });

  final String? hint;
  final String? title;
  final TimeOfDay? initialValue;
  final void Function(TimeOfDay)? onChanged;
  final TextEditingController? controller;
  final String? Function(TimeOfDay?)? validator;
  final bool isRequired;

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  late final ValueNotifier<TimeOfDay?> _time;
  late final TextEditingController _controller;

  @override
  void initState() {
    _time = ValueNotifier<TimeOfDay?>(widget.initialValue);
    _controller = widget.controller ?? TextEditingController();
    _controller.text = _formatTime(_time.value);
    _time.addListener(() => _controller.text = _formatTime(_time.value));
    super.initState();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _time,
      builder: (context, timeOfDay, child) {
        return FormField<TimeOfDay?>(
          validator:
              widget.validator ??
              (time) => Validator.validateRequired(
                time.toString(),
                isRequired: widget.isRequired,
                title: LocaleKeys.details_date_time_time.tr(),
              ),
          builder: (FormFieldState<TimeOfDay?> formState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  isRequired: widget.isRequired,
                  controller: _controller,
                  title: widget.title ?? LocaleKeys.details_date_time_time.tr(),
                  hint: widget.hint ?? LocaleKeys.details_date_time_time.tr().selectHint,
                  readOnly: true,
                  suffixIcon: Assets.icons.clock.path,
                  onTap: () async {
                    if (!context.isAndroid) {
                      final time = await showTimePicker(context: context, initialTime: _time.value ?? TimeOfDay.now());
                      if (time != null) {
                        _time.value = time;
                        widget.onChanged?.call(time);
                        formState.didChange(time);
                      }
                    } else {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          TimeOfDay pickedTime = _time.value ?? TimeOfDay.now();
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
                                      child: Text(LocaleKeys.actions_done.tr()).clickable(
                                        style: context.titleLarge.bold.s14,
                                        padding: 16.edgeInsetsAll.copyWith(bottom: 0),
                                        onTap: () {
                                          context.pop();
                                          _time.value = pickedTime;
                                          widget.onChanged?.call(pickedTime);
                                          formState.didChange(pickedTime);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.time,
                                  initialDateTime: DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                    _time.value?.hour ?? DateTime.now().hour,
                                    _time.value?.minute ?? DateTime.now().minute,
                                  ),
                                  onDateTimeChanged: (value) {
                                    pickedTime = TimeOfDay(hour: value.hour, minute: value.minute);
                                  },
                                ).withHeight(240),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                if (formState.hasError) Text(formState.errorText!, style: context.errorStyle).paddingTop(8),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _time.dispose();
    super.dispose();
  }
}
