import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../../../core/utils/app_icons.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showCancel;
  final IconData? icon;
  final Color? iconColor;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showCancel = true,
    this.icon,
    this.iconColor,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool showCancel = true,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        showCancel: showCancel,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? theme.colorScheme.primary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: content ??
          (message != null
              ? Text(
                  message!,
                  style: theme.textTheme.bodyMedium,
                )
              : null),
      actions: [
        if (showCancel)
          AppButton(
            text: cancelText ?? 'Cancel',
            type: AppButtonType.text,
            onPressed: () {
              if (onCancel != null) {
                onCancel!();
              } else {
                Navigator.of(context).pop(false);
              }
            },
          ),
        AppButton(
          text: confirmText ?? 'OK',
          type: AppButtonType.primary,
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            } else {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ],
    );
  }
}

class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? iconColor;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.onPressed,
    this.icon,
    this.iconColor,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AppAlertDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      message: message,
      confirmText: buttonText,
      showCancel: false,
      onConfirm: onPressed ?? () => Navigator.of(context).pop(),
      icon: icon ?? AppIcons.info,
      iconColor: iconColor,
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm ?? () => Navigator.of(context).pop(true),
      onCancel: onCancel ?? () => Navigator.of(context).pop(false),
      icon: AppIcons.warning,
      iconColor: AppColors.getWarning(Theme.of(context).brightness),
    );
  }
}

