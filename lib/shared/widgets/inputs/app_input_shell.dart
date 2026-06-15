import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme_extensions.dart';

class AppInputShell extends StatelessWidget {
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool enabled;
  final Widget child;

  const AppInputShell({
    super.key,
    this.label,
    this.helperText,
    this.errorText,
    this.enabled = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label!, style: theme.textTheme.labelLarge),
          ),
        Opacity(opacity: enabled ? 1 : 0.7, child: child),
        if (helperText != null || errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12, right: 12),
            child: Text(
              errorText ?? helperText ?? '',
              style: theme.textTheme.bodySmall?.copyWith(
                color: errorText != null
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}

class AppInputSurface extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final bool focused;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const AppInputSurface({
    super.key,
    required this.child,
    this.enabled = true,
    this.focused = false,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.appColors;
    final radius = BorderRadius.circular(AppConstants.defaultBorderRadius);
    final backgroundColor = focused
        ? colors.fieldBorderActive.withValues(alpha: 0.12)
        : (enabled ? colors.fieldBackground : colors.fieldBackgroundDisabled);

    return Material(
      color: backgroundColor,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: enabled ? onTap : null,
        child: AnimatedContainer(
          duration: AppConstants.shortAnimationDuration,
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: 16,
              ),
          decoration: BoxDecoration(borderRadius: radius),
          child: child,
        ),
      ),
    );
  }
}
