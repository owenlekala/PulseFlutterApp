import 'package:flutter/material.dart';

import '../../../core/utils/app_icons.dart';
import '../buttons/app_icon_button.dart';
import 'app_upload_models.dart';

class AppFilePreviewChip extends StatelessWidget {
  final AppUploadItem item;
  final VoidCallback? onPreview;
  final VoidCallback? onRemove;

  const AppFilePreviewChip({
    super.key,
    required this.item,
    this.onPreview,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.file, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            item.typeLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (onPreview != null) ...[
            const SizedBox(width: 4),
            AppIconButton(
              icon: AppIcons.eye,
              size: 18,
              padding: EdgeInsets.zero,
              onPressed: onPreview,
              tooltip: 'Preview file',
            ),
          ],
          if (onRemove != null) ...[
            const SizedBox(width: 2),
            AppIconButton(
              icon: AppIcons.close,
              size: 18,
              padding: EdgeInsets.zero,
              onPressed: onRemove,
              tooltip: 'Remove file',
            ),
          ],
        ],
      ),
    );
  }
}
