import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_extensions.dart';

enum AppStatusTone { neutral, success, warning, error, info }

class AppStatusChip extends StatelessWidget {
  final String label;
  final AppStatusTone tone;

  const AppStatusChip({
    super.key,
    required this.label,
    this.tone = AppStatusTone.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.appColors;
    final (background, foreground) = switch (tone) {
      AppStatusTone.success => (
        semantic.chipSuccessBackground,
        semantic.chipSuccessForeground,
      ),
      AppStatusTone.warning => (
        semantic.chipWarningBackground,
        semantic.chipWarningForeground,
      ),
      AppStatusTone.error => (
        semantic.chipErrorBackground,
        semantic.chipErrorForeground,
      ),
      AppStatusTone.info => (theme.colorScheme.primary, Colors.white),
      AppStatusTone.neutral => (
        semantic.chipNeutralBackground,
        semantic.chipNeutralForeground,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
