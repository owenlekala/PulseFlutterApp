import 'package:flutter/material.dart';

enum AppButtonType {
  primary,
  secondary,
  outlined,
  text,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
            padding: padding ?? _getPadding(),
            minimumSize: isFullWidth ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Fully rounded ends
            ),
            elevation: 2,
          ),
          child: _buildChild(context),
        );
        break;
      case AppButtonType.secondary:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.secondary,
            foregroundColor: foregroundColor ?? theme.colorScheme.onSecondary,
            padding: padding ?? _getPadding(),
            minimumSize: isFullWidth ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Fully rounded ends
            ),
            elevation: 2,
          ),
          child: _buildChild(context),
        );
        break;
      case AppButtonType.outlined:
        button = OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            padding: padding ?? _getPadding(),
            minimumSize: isFullWidth ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Fully rounded ends
            ),
            side: BorderSide(
              color: foregroundColor ?? theme.colorScheme.primary,
              width: 2,
            ),
          ),
          child: _buildChild(context),
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            padding: padding ?? _getPadding(),
            minimumSize: isFullWidth ? const Size(double.infinity, 0) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50), // Fully rounded ends
            ),
          ),
          child: _buildChild(context),
        );
        break;
    }

    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600, // Increased font weight
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600, // Increased font weight
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 16); // Increased height
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 36, vertical: 20); // Increased height
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}