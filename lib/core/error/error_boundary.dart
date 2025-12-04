import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../theme/app_colors.dart';
import '../utils/app_icons.dart';
import '../../shared/widgets/buttons/app_button.dart';
import '../../shared/widgets/snackbars/app_snackbar.dart';

/// Error Boundary Widget
/// Catches errors in the widget tree and displays an error screen
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Object error, StackTrace? stack)?
      errorBuilder;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Set up error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      if (mounted) {
        setState(() {
          _error = details.exception;
          _stackTrace = details.stack;
          _hasError = true;
        });
      }
      // Also log to console in debug mode
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error!, _stackTrace);
      }
      return ErrorScreen(
        error: _error!,
        stackTrace: _stackTrace,
        onRetry: () {
          setState(() {
            _error = null;
            _stackTrace = null;
            _hasError = false;
          });
        },
      );
    }

    return widget.child;
  }
}

/// Custom Error Screen Widget
class ErrorScreen extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? title;
  final String? message;

  const ErrorScreen({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.title,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDebugMode = kDebugMode;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Icon(
                  AppIcons.error,
                  size: 80,
                  color: AppColors.getError(brightness),
                ),
                const SizedBox(height: 24),
                // Error Title
                Text(
                  title ?? 'Something went wrong',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.getError(brightness),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Error Message
                Text(
                  message ?? error.toString(),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (isDebugMode && stackTrace != null) ...[
                  const SizedBox(height: 24),
                  // Stack Trace (only in debug mode)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stack Trace:',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            stackTrace.toString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                // Action Buttons
                if (onRetry != null)
                  AppButton(
                    text: 'Retry',
                    type: AppButtonType.primary,
                    onPressed: onRetry,
                    isFullWidth: true,
                  ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Go Home',
                  type: AppButtonType.outlined,
                  onPressed: () {
                    // Navigate to home
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (route) => false,
                    );
                  },
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Error Handler Utility
class ErrorHandler {
  /// Handle and display error
  static void handleError(
    BuildContext context,
    Object error, {
    StackTrace? stackTrace,
    String? title,
    String? message,
    VoidCallback? onRetry,
  }) {
    if (kDebugMode) {
      debugPrint('Error: $error');
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              AppIcons.error,
              color: AppColors.getError(Theme.of(context).brightness),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title ?? 'Error'),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message ?? error.toString()),
              if (kDebugMode && stackTrace != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Stack Trace:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stackTrace.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 10,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          if (onRetry != null)
            AppButton(
              text: 'Retry',
              type: AppButtonType.primary,
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
            ),
          AppButton(
            text: 'OK',
            type: AppButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    AppSnackBar.showError(
      context,
      message,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show success snackbar
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    AppSnackBar.showSuccess(
      context,
      message,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

