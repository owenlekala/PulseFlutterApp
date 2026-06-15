import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'app_empty_image.dart';

class AppNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          width: width,
          height: height,
          child: const AppEmptyImage(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) => SizedBox(
          width: width,
          height: height,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, _, __) => SizedBox(
          width: width,
          height: height,
          child: const AppEmptyImage(message: 'Image unavailable'),
        ),
      ),
    );
  }
}
