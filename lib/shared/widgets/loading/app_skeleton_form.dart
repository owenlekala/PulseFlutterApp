import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/theme/app_theme_extensions.dart';

class AppSkeletonForm extends StatelessWidget {
  final int fieldCount;

  const AppSkeletonForm({super.key, this.fieldCount = 4});

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
      child: Column(
        children: List.generate(
          fieldCount,
          (index) => const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: _SkeletonField(),
          ),
        ),
      ),
    );
  }
}

class _SkeletonField extends StatelessWidget {
  const _SkeletonField();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Bone.text(words: 2, fontSize: 12),
        SizedBox(height: 8),
        Bone(
          width: double.infinity,
          height: 54,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ],
    );
  }
}
