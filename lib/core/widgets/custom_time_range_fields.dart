import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'time_picker_field.dart';

class CustomTimeRangeFields extends StatefulWidget {
  const CustomTimeRangeFields({super.key, required this.onChanged, this.initialStartTime, this.initialEndTime});

  final void Function(TimeOfDay?, TimeOfDay?) onChanged;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;

  @override
  State<CustomTimeRangeFields> createState() => _CustomDateRangeFieldsState();
}

class _CustomDateRangeFieldsState extends State<CustomTimeRangeFields> {
  final ValueNotifier<TimeOfDay?> _startDateNotifier = ValueNotifier(null);
  final ValueNotifier<TimeOfDay?> _endDateNotifier = ValueNotifier(null);

  void _onChanged() {
    widget.onChanged(_startDateNotifier.value, _endDateNotifier.value);
  }

  @override
  void initState() {
    _startDateNotifier.value = widget.initialStartTime;
    _endDateNotifier.value = widget.initialEndTime;
    _startDateNotifier.addListener(_onChanged);
    _endDateNotifier.addListener(_onChanged);
    super.initState();
  }

  @override
  void dispose() {
    _startDateNotifier.removeListener(_onChanged);
    _endDateNotifier.removeListener(_onChanged);
    _startDateNotifier.dispose();
    _endDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => Validator.validateTimeRange(_startDateNotifier.value, _endDateNotifier.value),
      builder: (FormFieldState<TimeOfDay> formState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                TimePickerField(
                  initialValue: _startDateNotifier.value,
                  title: LocaleKeys.details_date_time_start_time.tr(),
                  hint: LocaleKeys.details_date_time_start_time.tr().selectHint,
                  onChanged: (date) {
                    _startDateNotifier.value = date;
                    formState.didChange(_startDateNotifier.value);
                  },
                ).expand(),
                16.gap,
                TimePickerField(
                  initialValue: _endDateNotifier.value,
                  title: LocaleKeys.details_date_time_end_time.tr(),
                  hint: LocaleKeys.details_date_time_end_time.tr().selectHint,
                  onChanged: (date) {
                    _endDateNotifier.value = date;
                    formState.didChange(_endDateNotifier.value);
                  },
                ).expand(),
              ],
            ),
            if (formState.hasError) Text(formState.errorText!, style: context.errorStyle).paddingTop(8),
          ],
        );
      },
    );
  }
}
