import 'package:flutter/material.dart';

import 'app_input_shell.dart';

class AppSegmentOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const AppSegmentOption({required this.value, required this.label, this.icon});
}

class AppSegmentedField<T> extends StatelessWidget {
  final String? label;
  final String? helperText;
  final String? errorText;
  final T value;
  final List<AppSegmentOption<T>> options;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const AppSegmentedField({
    super.key,
    this.label,
    this.helperText,
    this.errorText,
    required this.value,
    required this.options,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppInputShell(
      label: label,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SegmentedButton<T>(
          segments: options
              .map(
                (option) => ButtonSegment<T>(
                  value: option.value,
                  label: Text(option.label),
                  icon: option.icon != null ? Icon(option.icon) : null,
                ),
              )
              .toList(),
          selected: {value},
          onSelectionChanged: enabled && onChanged != null
              ? (selection) => onChanged!(selection.first)
              : null,
          showSelectedIcon: false,
          multiSelectionEnabled: false,
        ),
      ),
    );
  }
}
