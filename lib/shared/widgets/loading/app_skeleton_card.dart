import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_theme_extensions.dart';
import '../cards/app_card.dart';

class AppSkeletonCard extends StatelessWidget {
  final double height;

  const AppSkeletonCard({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Skeletonizer(
      enabled: true,
      containersColor: theme.appColors.skeletonBase,
      effect: ShimmerEffect(
        baseColor: theme.appColors.skeletonBase,
        highlightColor: theme.appColors.skeletonHighlight,
      ),
      child: AppCard(
        child: SizedBox(height: height, child: const _SkeletonCardContent()),
      ),
    );
  }
}

class _SkeletonCardContent extends StatelessWidget {
  const _SkeletonCardContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bone.text(words: 2, fontSize: 20),
        SizedBox(height: 12),
        Bone.text(words: 6),
        SizedBox(height: 8),
        Bone.text(words: 5),
        Spacer(),
        Bone.button(width: 120, height: 42),
      ],
    );
  }
}
