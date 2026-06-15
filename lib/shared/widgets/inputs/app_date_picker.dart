import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_cupertino_date_time_field.dart';

@Deprecated('Use AppDateField instead.')
class AppDatePicker extends StatelessWidget {
  final String? label;
  final String? hint;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? selectedDate;
  final void Function(DateTime)? onDateSelected;
  final String? Function(DateTime?)? validator;
  final bool enabled;
  final String? helperText;
  final String? errorText;
  final DateFormat? dateFormat;

  const AppDatePicker({
    super.key,
    this.label,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.selectedDate,
    this.onDateSelected,
    this.validator,
    this.enabled = true,
    this.helperText,
    this.errorText,
    this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = selectedDate ?? initialDate;

    return AppDateField(
      value: effectiveValue,
      minimumDate: firstDate,
      maximumDate: lastDate,
      label: label,
      placeholder: hint,
      helperText: helperText,
      errorText: errorText ?? validator?.call(selectedDate),
      onChanged: onDateSelected,
      enabled: enabled,
    );
  }
}
