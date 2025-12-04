import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AppCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.onTap,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardElevation = elevation ?? AppConstants.defaultElevation;
    final cardBorderRadius = borderRadius ??
        BorderRadius.circular(AppConstants.defaultBorderRadius);

    Widget card = Container(
      padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? theme.cardColor,
        borderRadius: cardBorderRadius,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: cardElevation * 2,
                offset: Offset(0, cardElevation),
              ),
            ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: cardBorderRadius,
        child: card,
      );
    }

    return card;
  }
}

