import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/config/extensions/all_extensions.dart';
import '../../core/resources/resources.dart';
import '../../core/utils/validators.dart';
import 'date_picker_field.dart';

class CustomDateRangeFields extends StatefulWidget {
  const CustomDateRangeFields({
    super.key,
    required this.onChanged,
    this.initialStartDate,
    this.initialEndDate,
  });

  final void Function(DateTime?, DateTime?) onChanged;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  @override
  State<CustomDateRangeFields> createState() => _CustomDateRangeFieldsState();
}

class _CustomDateRangeFieldsState extends State<CustomDateRangeFields> {
  final ValueNotifier<DateTime?> _startDateNotifier = ValueNotifier(null);
  final ValueNotifier<DateTime?> _endDateNotifier = ValueNotifier(null);

  void _onChanged() {
    widget.onChanged(_startDateNotifier.value, _endDateNotifier.value);
  }

  @override
  void initState() {
    _startDateNotifier.value = widget.initialStartDate;
    _endDateNotifier.value = widget.initialEndDate;
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
      validator: (_) => Validator.validateDateRange(_startDateNotifier.value, _endDateNotifier.value),
      builder: (FormFieldState<DateTime> formState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DatePickerField(
                  initialValue: _startDateNotifier.value,
                  minDate: DateTime.now().startOfDay,
                  title: LocaleKeys.details_date_time_start.tr(),
                  hint: LocaleKeys.details_date_time_start.tr().selectHint,
                  onChanged: (date) {
                    _startDateNotifier.value = date;
                    formState.didChange(_startDateNotifier.value);
                  },
                ).expand(),
                16.gap,
                DatePickerField(
                  initialValue: _endDateNotifier.value,
                  minDate: DateTime.now().startOfDay,
                  title: LocaleKeys.details_date_time_end.tr(),
                  hint: LocaleKeys.details_date_time_end.tr().selectHint,
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
