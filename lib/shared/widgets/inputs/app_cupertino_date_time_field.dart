import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme_extensions.dart';
import '../../../core/utils/app_icons.dart';
import 'app_input_shell.dart';

enum AppCupertinoDateTimeFieldMode { date, time, dateTime }

class AppCupertinoDateTimeField extends StatefulWidget {
  final AppCupertinoDateTimeFieldMode mode;
  final DateTime? value;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final int minuteInterval;
  final bool use24hFormat;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ValueChanged<DateTime>? onChanged;
  final bool enabled;

  const AppCupertinoDateTimeField({
    super.key,
    required this.mode,
    this.value,
    this.minimumDate,
    this.maximumDate,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  }) : assert(minuteInterval > 0 && 60 % minuteInterval == 0);

  @override
  State<AppCupertinoDateTimeField> createState() =>
      _AppCupertinoDateTimeFieldState();
}

class _AppCupertinoDateTimeFieldState extends State<AppCupertinoDateTimeField> {
  Future<void> _openPicker() async {
    if (!widget.enabled) {
      return;
    }

    final now = DateTime.now();
    final initialValue = _normalized(
      widget.value ?? now,
      widget.mode,
      widget.minuteInterval,
    );
    DateTime temporaryValue = initialValue;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.appColors;

        return Container(
          height: 320,
          color: colors.sheetBackground,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      Text(
                        widget.label ?? 'Select value',
                        style: theme.textTheme.titleMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          widget.onChanged?.call(temporaryValue);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: _pickerMode(widget.mode),
                    initialDateTime: initialValue,
                    minimumDate: widget.minimumDate,
                    maximumDate: widget.maximumDate,
                    use24hFormat: widget.use24hFormat,
                    minuteInterval: widget.minuteInterval,
                    onDateTimeChanged: (value) {
                      temporaryValue = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = widget.value != null;
    final inputTextStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: hasValue
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant,
    );

    return AppInputShell(
      label: widget.label,
      helperText: widget.helperText,
      errorText: widget.errorText,
      enabled: widget.enabled,
      child: AppInputSurface(
        enabled: widget.enabled,
        onTap: _openPicker,
        child: Row(
          children: [
            Icon(
              _prefixIcon(widget.mode),
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasValue
                    ? _formatValue(
                        widget.value!,
                        widget.mode,
                        widget.use24hFormat,
                      )
                    : (widget.placeholder ?? _defaultPlaceholder(widget.mode)),
                style: inputTextStyle,
              ),
            ),
            Icon(
              Icons.unfold_more_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class AppDateField extends StatelessWidget {
  final DateTime? value;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ValueChanged<DateTime>? onChanged;
  final bool enabled;

  const AppDateField({
    super.key,
    this.value,
    this.minimumDate,
    this.maximumDate,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCupertinoDateTimeField(
      mode: AppCupertinoDateTimeFieldMode.date,
      value: value,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}

class AppTimeField extends StatelessWidget {
  final DateTime? value;
  final int minuteInterval;
  final bool use24hFormat;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ValueChanged<DateTime>? onChanged;
  final bool enabled;

  const AppTimeField({
    super.key,
    this.value,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCupertinoDateTimeField(
      mode: AppCupertinoDateTimeFieldMode.time,
      value: value,
      minuteInterval: minuteInterval,
      use24hFormat: use24hFormat,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}

class AppDateTimeField extends StatelessWidget {
  final DateTime? value;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final int minuteInterval;
  final bool use24hFormat;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ValueChanged<DateTime>? onChanged;
  final bool enabled;

  const AppDateTimeField({
    super.key,
    this.value,
    this.minimumDate,
    this.maximumDate,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCupertinoDateTimeField(
      mode: AppCupertinoDateTimeFieldMode.dateTime,
      value: value,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      minuteInterval: minuteInterval,
      use24hFormat: use24hFormat,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      onChanged: onChanged,
      enabled: enabled,
    );
  }
}

class AppDateRangeField extends StatelessWidget {
  final DateTimeRange? value;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final ValueChanged<DateTimeRange>? onChanged;
  final bool enabled;
  final String dateFormatPattern;

  const AppDateRangeField({
    super.key,
    this.value,
    this.minimumDate,
    this.maximumDate,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.dateFormatPattern = AppConstants.dateFormat,
  });

  Future<void> _selectRange(BuildContext context) async {
    if (!enabled) {
      return;
    }

    final now = DateTime.now();
    final firstDate = minimumDate ?? DateTime(now.year - 5);
    final lastDate = maximumDate ?? DateTime(now.year + 5);
    final initialRange =
        value ??
        DateTimeRange(
          start: DateTime(now.year, now.month, now.day),
          end: DateTime(
            now.year,
            now.month,
            now.day,
          ).add(const Duration(days: 1)),
        );
    DateTime start = _clampDate(
      DateTime(
        initialRange.start.year,
        initialRange.start.month,
        initialRange.start.day,
      ),
      firstDate,
      lastDate,
    );
    DateTime end = _clampDate(
      DateTime(
        initialRange.end.year,
        initialRange.end.month,
        initialRange.end.day,
      ),
      firstDate,
      lastDate,
    );
    var anchor = _RangeSelectionAnchor.start;

    if (end.isBefore(start)) {
      end = start;
    }

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colors = theme.appColors;
        final dateTextStyle = CupertinoTheme.of(
          context,
        ).textTheme.dateTimePickerTextStyle;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final rangeLabel =
                '${DateFormat(dateFormatPattern).format(start)} - ${DateFormat(dateFormatPattern).format(end)}';
            final pickerValue = anchor == _RangeSelectionAnchor.start
                ? start
                : end;

            return Container(
              height: 360,
              color: colors.sheetBackground,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  label ?? 'Select date range',
                                  style: theme.textTheme.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  rangeLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              onChanged?.call(
                                DateTimeRange(start: start, end: end),
                              );
                            },
                            child: const Text('Done'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child:
                          CupertinoSlidingSegmentedControl<
                            _RangeSelectionAnchor
                          >(
                            groupValue: anchor,
                            children: {
                              _RangeSelectionAnchor.start: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Text(
                                  'Start',
                                  style: dateTextStyle.copyWith(fontSize: 14),
                                ),
                              ),
                              _RangeSelectionAnchor.end: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Text(
                                  'End',
                                  style: dateTextStyle.copyWith(fontSize: 14),
                                ),
                              ),
                            },
                            onValueChanged: (selection) {
                              if (selection == null) {
                                return;
                              }
                              setModalState(() => anchor = selection);
                            },
                          ),
                    ),
                    Expanded(
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: pickerValue,
                        minimumDate: firstDate,
                        maximumDate: lastDate,
                        onDateTimeChanged: (selected) {
                          setModalState(() {
                            final normalized = DateTime(
                              selected.year,
                              selected.month,
                              selected.day,
                            );
                            if (anchor == _RangeSelectionAnchor.start) {
                              start = normalized;
                              if (end.isBefore(start)) {
                                end = start;
                              }
                            } else {
                              end = normalized;
                              if (end.isBefore(start)) {
                                start = end;
                              }
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = DateFormat(dateFormatPattern);
    final hasValue = value != null;
    final inputTextStyle = theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: hasValue
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant,
    );
    final displayText = hasValue
        ? '${format.format(value!.start)} - ${format.format(value!.end)}'
        : (placeholder ?? 'Select date range');

    return AppInputShell(
      label: label,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: AppInputSurface(
        enabled: enabled,
        onTap: () => _selectRange(context),
        child: Row(
          children: [
            Icon(AppIcons.calendar, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(displayText, style: inputTextStyle)),
            Icon(
              Icons.swap_horiz_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

CupertinoDatePickerMode _pickerMode(AppCupertinoDateTimeFieldMode mode) {
  switch (mode) {
    case AppCupertinoDateTimeFieldMode.date:
      return CupertinoDatePickerMode.date;
    case AppCupertinoDateTimeFieldMode.time:
      return CupertinoDatePickerMode.time;
    case AppCupertinoDateTimeFieldMode.dateTime:
      return CupertinoDatePickerMode.dateAndTime;
  }
}

String _formatValue(
  DateTime value,
  AppCupertinoDateTimeFieldMode mode,
  bool use24hFormat,
) {
  switch (mode) {
    case AppCupertinoDateTimeFieldMode.date:
      return DateFormat(AppConstants.dateFormat).format(value);
    case AppCupertinoDateTimeFieldMode.time:
      return DateFormat(use24hFormat ? 'HH:mm' : 'hh:mm a').format(value);
    case AppCupertinoDateTimeFieldMode.dateTime:
      return DateFormat(
        use24hFormat ? 'dd-MM-yyyy HH:mm' : 'dd-MM-yyyy hh:mm a',
      ).format(value);
  }
}

String _defaultPlaceholder(AppCupertinoDateTimeFieldMode mode) {
  switch (mode) {
    case AppCupertinoDateTimeFieldMode.date:
      return 'Select date';
    case AppCupertinoDateTimeFieldMode.time:
      return 'Select time';
    case AppCupertinoDateTimeFieldMode.dateTime:
      return 'Select date and time';
  }
}

IconData _prefixIcon(AppCupertinoDateTimeFieldMode mode) {
  switch (mode) {
    case AppCupertinoDateTimeFieldMode.date:
      return AppIcons.calendar;
    case AppCupertinoDateTimeFieldMode.time:
      return AppIcons.clock;
    case AppCupertinoDateTimeFieldMode.dateTime:
      return AppIcons.calendar;
  }
}

DateTime _normalized(
  DateTime value,
  AppCupertinoDateTimeFieldMode mode,
  int minuteInterval,
) {
  final roundedMinute =
      (value.minute / minuteInterval).round() * minuteInterval;
  final adjusted = value.add(Duration(minutes: roundedMinute - value.minute));

  switch (mode) {
    case AppCupertinoDateTimeFieldMode.date:
      return DateTime(adjusted.year, adjusted.month, adjusted.day);
    case AppCupertinoDateTimeFieldMode.time:
      final today = DateTime.now();
      return DateTime(
        today.year,
        today.month,
        today.day,
        adjusted.hour,
        adjusted.minute % 60,
      );
    case AppCupertinoDateTimeFieldMode.dateTime:
      return adjusted;
  }
}

DateTime _clampDate(DateTime value, DateTime minimum, DateTime maximum) {
  if (value.isBefore(minimum)) {
    return DateTime(minimum.year, minimum.month, minimum.day);
  }
  if (value.isAfter(maximum)) {
    return DateTime(maximum.year, maximum.month, maximum.day);
  }
  return value;
}

enum _RangeSelectionAnchor { start, end }
