import 'package:flutter/material.dart';

enum AppLoadingType {
  circular,
  linear,
}

class AppLoadingIndicator extends StatelessWidget {
  final AppLoadingType type;
  final Color? color;
  final double? size;
  final double? strokeWidth;
  final String? message;

  const AppLoadingIndicator({
    super.key,
    this.type = AppLoadingType.circular,
    this.color,
    this.size,
    this.strokeWidth,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;

    Widget indicator;

    switch (type) {
      case AppLoadingType.circular:
        indicator = SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth ?? 3,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        );
        break;
      case AppLoadingType.linear:
        indicator = LinearProgressIndicator(
          minHeight: strokeWidth ?? 4,
          valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          backgroundColor: indicatorColor.withOpacity(0.2),
        );
        break;
    }

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return indicator;
  }
}

