import 'package:flutter/material.dart';
import '../../../core/utils/app_icons.dart';

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

  Future<void> _selectTime(BuildContext context) async {
    if (!enabled) return;

    final TimeOfDay initial = selectedTime ?? initialTime ?? TimeOfDay.now();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (picked != null && onTimeSelected != null) {
      onTimeSelected!(picked);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    
    if (use24HourFormat) {
      return '$hour:$minute';
    } else {
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      return '$hour12:$minute $period';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = selectedTime != null
        ? _formatTime(selectedTime!)
        : (hint ?? 'Select time');

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
          onTap: enabled ? () => _selectTime(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint ?? 'Select time',
              prefixIcon: Icon(
                AppIcons.clock,
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
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            child: Text(
              displayText,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selectedTime != null
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        if (validator != null && selectedTime != null)
          Builder(
            builder: (context) {
              final error = validator!(selectedTime);
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

