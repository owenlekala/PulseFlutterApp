import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_extensions.dart';
import 'app_upload_models.dart';

class AppUploadProgressRow extends StatelessWidget {
  final double progress;
  final AppUploadState state;
  final String? leadingText;

  const AppUploadProgressRow({
    super.key,
    required this.progress,
    this.state = AppUploadState.uploading,
    this.leadingText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalized = progress.clamp(0.0, 1.0).toDouble();
    final color = switch (state) {
      AppUploadState.failed => theme.colorScheme.error,
      AppUploadState.uploaded => theme.colorScheme.primary,
      _ => theme.colorScheme.primary,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                leadingText ?? 'Upload progress',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Text(
              '${(normalized * 100).round()}%',
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: normalized,
            backgroundColor: theme.appColors.skeletonBase,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
