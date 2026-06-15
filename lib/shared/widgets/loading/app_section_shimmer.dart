import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_theme_extensions.dart';

class AppSectionShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppSectionShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: enabled,
      containersColor: theme.appColors.skeletonBase,
      effect: ShimmerEffect(
        baseColor: theme.appColors.skeletonBase,
        highlightColor: theme.appColors.skeletonHighlight,
      ),
      child: child,
    );
  }
}
