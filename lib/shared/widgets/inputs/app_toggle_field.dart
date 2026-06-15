import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme_extensions.dart';
import 'app_input_shell.dart';

class AppToggleField extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final String? helperText;
  final String? errorText;
  final Widget? leading;

  const AppToggleField({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.helperText,
    this.errorText,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppInputShell(
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      child: AppInputSurface(
        enabled: enabled,
        onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            CupertinoSwitch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeTrackColor: theme.appColors.fieldBorderActive,
            ),
          ],
        ),
      ),
    );
  }
}
