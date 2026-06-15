import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_theme_extensions.dart';
import '../../../core/utils/app_icons.dart';
import '../cards/app_card.dart';
import '../uploads/app_file_preview_chip.dart';
import '../uploads/app_upload_models.dart';
import '../uploads/app_upload_tile.dart';

class AppUploadCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final AppUploadSource source;
  final AppUploadState state;
  final List<AppUploadItem> items;
  final VoidCallback? onTap;
  final ValueChanged<AppUploadItem>? onRemoveItem;
  final ValueChanged<AppUploadItem>? onRetryItem;
  final ValueChanged<AppUploadItem>? onPreviewItem;
  final bool enabled;

  const AppUploadCard({
    super.key,
    required this.title,
    this.subtitle,
    this.source = AppUploadSource.mixed,
    this.state = AppUploadState.idle,
    this.items = const [],
    this.onTap,
    this.onRemoveItem,
    this.onRetryItem,
    this.onPreviewItem,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final semantic = theme.appColors;
    final surface = switch (state) {
      AppUploadState.uploaded => semantic.uploadSuccessSurface,
      AppUploadState.failed => semantic.uploadErrorSurface,
      AppUploadState.uploading ||
      AppUploadState.picking => semantic.uploadWarningSurface,
      _ => semantic.uploadIdleSurface,
    };

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: enabled ? onTap : null,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      color: theme.colorScheme.outline,
                      strokeWidth: 1.5,
                      dashPattern: const [6, 4],
                      radius: const Radius.circular(20),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: enabled
                            ? surface
                            : semantic.fieldBackgroundDisabled,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _iconForSource(source),
                            size: 32,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _headlineForState(state),
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _bodyForSource(source),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 250.ms)
              .scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1)),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items
                  .map(
                    (item) => AppFilePreviewChip(
                      item: item,
                      onPreview: item.isPreviewable && onPreviewItem != null
                          ? () => onPreviewItem!(item)
                          : null,
                      onRemove: onRemoveItem != null
                          ? () => onRemoveItem!(item)
                          : null,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppUploadTile(
                  item: item,
                  onPreview: item.isPreviewable && onPreviewItem != null
                      ? () => onPreviewItem!(item)
                      : null,
                  onRemove: onRemoveItem != null
                      ? () => onRemoveItem!(item)
                      : null,
                  onRetry: onRetryItem != null
                      ? () => onRetryItem!(item)
                      : null,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

IconData _iconForSource(AppUploadSource source) {
  switch (source) {
    case AppUploadSource.document:
      return AppIcons.document;
    case AppUploadSource.image:
      return AppIcons.image;
    case AppUploadSource.mixed:
      return AppIcons.upload;
  }
}

String _headlineForState(AppUploadState state) {
  switch (state) {
    case AppUploadState.idle:
      return 'Tap to add files';
    case AppUploadState.picking:
      return 'Choosing files';
    case AppUploadState.uploading:
      return 'Uploading files';
    case AppUploadState.uploaded:
      return 'Files ready';
    case AppUploadState.failed:
      return 'Upload failed';
    case AppUploadState.disabled:
      return 'Uploads unavailable';
  }
}

String _bodyForSource(AppUploadSource source) {
  switch (source) {
    case AppUploadSource.document:
      return 'Choose PDFs or documents and keep their progress visible.';
    case AppUploadSource.image:
      return 'Use gallery or camera media with preview and retry actions.';
    case AppUploadSource.mixed:
      return 'Handle documents and media in one consistent shared surface.';
  }
}
