import 'package:flutter/material.dart';

import 'app_cupertino_date_time_field.dart';

@Deprecated('Use AppTimeField instead.')
class AppTimePicker extends StatelessWidget {
  final String? label;
  final String? hint;
  final TimeOfDay? initialTime;
  final TimeOfDay? selectedTime;
  final void Function(TimeOfDay)? onTimeSelected;
  final String? Function(TimeOfDay?)? validator;
  final bool enabled;
  final String? helperText;
  final String? errorText;
  final bool use24HourFormat;

  const AppTimePicker({
    super.key,
    this.label,
    this.hint,
    this.initialTime,
    this.selectedTime,
    this.onTimeSelected,
    this.validator,
    this.enabled = true,
    this.helperText,
    this.errorText,
    this.use24HourFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    final seed = selectedTime ?? initialTime;
    final now = DateTime.now();
    final value = seed == null
        ? null
        : DateTime(now.year, now.month, now.day, seed.hour, seed.minute);

    return AppTimeField(
      value: value,
      label: label,
      placeholder: hint,
      helperText: helperText,
      errorText: errorText ?? validator?.call(selectedTime),
      enabled: enabled,
      use24hFormat: use24HourFormat,
      onChanged: (picked) {
        onTimeSelected?.call(TimeOfDay.fromDateTime(picked));
      },
    );
  }
}
