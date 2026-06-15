import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

enum AppUploadState { idle, picking, uploading, uploaded, failed, disabled }

enum AppUploadSource { document, image, mixed }

class AppUploadItem {
  final String id;
  final String name;
  final String? extension;
  final int sizeBytes;
  final double? progress;
  final AppUploadState state;
  final String? errorMessage;
  final bool isPreviewable;

  const AppUploadItem({
    required this.id,
    required this.name,
    this.extension,
    required this.sizeBytes,
    this.progress,
    this.state = AppUploadState.idle,
    this.errorMessage,
    this.isPreviewable = false,
  });

  factory AppUploadItem.fromPlatformFile(
    PlatformFile file, {
    AppUploadState state = AppUploadState.idle,
    double? progress,
    String? errorMessage,
    bool isPreviewable = false,
  }) {
    return AppUploadItem(
      id: file.identifier ?? file.path ?? file.name,
      name: file.name,
      extension: file.extension,
      sizeBytes: file.size,
      progress: progress,
      state: state,
      errorMessage: errorMessage,
      isPreviewable: isPreviewable,
    );
  }

  factory AppUploadItem.fromXFile(
    XFile file, {
    AppUploadState state = AppUploadState.idle,
    double? progress,
    String? errorMessage,
    bool isPreviewable = true,
  }) {
    return AppUploadItem(
      id: file.path,
      name: file.name,
      extension: file.name.contains('.')
          ? file.name.split('.').last.toLowerCase()
          : null,
      sizeBytes: 0,
      progress: progress,
      state: state,
      errorMessage: errorMessage,
      isPreviewable: isPreviewable,
    );
  }

  String get readableSize {
    if (sizeBytes <= 0) {
      return 'Unknown size';
    }

    const units = ['B', 'KB', 'MB', 'GB'];
    final base = math.log(sizeBytes) / math.log(1024);
    final unitIndex = base.floor().clamp(0, units.length - 1);
    final value = sizeBytes / math.pow(1024, unitIndex);

    return '${value.toStringAsFixed(value >= 10 ? 0 : 1)} ${units[unitIndex]}';
  }

  String get typeLabel {
    if (extension == null || extension!.isEmpty) {
      return 'FILE';
    }

    return extension!.toUpperCase();
  }
}
