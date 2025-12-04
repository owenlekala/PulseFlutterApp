import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/app_icons.dart';

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

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return;

    final DateTime now = DateTime.now();
    final DateTime first = firstDate ?? DateTime(now.year - 100);
    final DateTime last = lastDate ?? DateTime(now.year + 100);
    final DateTime initial = selectedDate ?? initialDate ?? now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = dateFormat ?? DateFormat('yyyy-MM-dd');
    final displayText = selectedDate != null
        ? format.format(selectedDate!)
        : (hint ?? 'Select date');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: theme.textTheme.labelLarge,
            ),
          ),
        InkWell(
          onTap: enabled ? () => _selectDate(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint ?? 'Select date',
              prefixIcon: Icon(
                AppIcons.calendar,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: Icon(
                Icons.arrow_drop_down,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              helperText: helperText,
              errorText: errorText,
              filled: true,
              fillColor: enabled
                  ? theme.colorScheme.surfaceVariant
                  : theme.colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            child: Text(
              displayText,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selectedDate != null
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (validator != null && selectedDate != null)
          Builder(
            builder: (context) {
              final error = validator!(selectedDate);
              if (error != null) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 12.0),
                  child: Text(
                    error,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}

