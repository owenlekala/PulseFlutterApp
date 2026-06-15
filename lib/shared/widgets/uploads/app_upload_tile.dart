import 'package:flutter/material.dart';

import '../../../core/utils/app_icons.dart';
import '../buttons/app_icon_button.dart';
import '../chips/app_status_chip.dart';
import 'app_upload_models.dart';
import 'app_upload_progress_row.dart';

class AppUploadTile extends StatelessWidget {
  final AppUploadItem item;
  final VoidCallback? onRetry;
  final VoidCallback? onRemove;
  final VoidCallback? onPreview;

  const AppUploadTile({
    super.key,
    required this.item,
    this.onRetry,
    this.onRemove,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.isPreviewable ? AppIcons.image : AppIcons.document,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.typeLabel} • ${item.readableSize}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppStatusChip(
                label: _statusLabel(item.state),
                tone: _statusTone(item.state),
              ),
            ],
          ),
          if (item.progress != null &&
              item.state == AppUploadState.uploading) ...[
            const SizedBox(height: 12),
            AppUploadProgressRow(progress: item.progress!, state: item.state),
          ],
          if (item.errorMessage != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onPreview != null && item.isPreviewable)
                AppIconButton(
                  icon: AppIcons.eye,
                  onPressed: onPreview,
                  tooltip: 'Preview file',
                ),
              if (onRetry != null && item.state == AppUploadState.failed) ...[
                const SizedBox(width: 8),
                AppIconButton(
                  icon: AppIcons.refresh,
                  onPressed: onRetry,
                  tooltip: 'Retry upload',
                ),
              ],
              if (onRemove != null) ...[
                const SizedBox(width: 8),
                AppIconButton(
                  icon: AppIcons.delete,
                  onPressed: onRemove,
                  tooltip: 'Remove file',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

String _statusLabel(AppUploadState state) {
  switch (state) {
    case AppUploadState.idle:
      return 'Ready';
    case AppUploadState.picking:
      return 'Picking';
    case AppUploadState.uploading:
      return 'Uploading';
    case AppUploadState.uploaded:
      return 'Uploaded';
    case AppUploadState.failed:
      return 'Failed';
    case AppUploadState.disabled:
      return 'Disabled';
  }
}

AppStatusTone _statusTone(AppUploadState state) {
  switch (state) {
    case AppUploadState.uploaded:
      return AppStatusTone.success;
    case AppUploadState.failed:
      return AppStatusTone.error;
    case AppUploadState.picking:
    case AppUploadState.uploading:
      return AppStatusTone.warning;
    case AppUploadState.disabled:
      return AppStatusTone.neutral;
    case AppUploadState.idle:
      return AppStatusTone.info;
  }
}
