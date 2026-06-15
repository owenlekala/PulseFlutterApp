import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_extensions.dart';
import '../../../core/utils/app_icons.dart';
import '../buttons/app_icon_button.dart';
import 'app_network_image.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final IconData editIcon;
  final Widget? placeholder;
  final bool showEditButton;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 24,
    this.onTap,
    this.onEdit,
    this.editIcon = Icons.camera_alt_rounded,
    this.placeholder,
    this.showEditButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diameter = radius * 2;

    Widget avatar = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipOval(child: _buildAvatarContent(context, diameter)),
    );

    if (onTap != null) {
      avatar = Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: avatar,
        ),
      );
    }

    if (!showEditButton) {
      return avatar;
    }

    final appColors = theme.appColors;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -2,
          bottom: -2,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.scaffoldBackgroundColor,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: AppIconButton(
              icon: editIcon,
              size: radius <= 20 ? 24 : 28,
              iconSize: radius <= 20 ? 14 : 16,
              backgroundColor: appColors.avatarEditBackground,
              foregroundColor: appColors.avatarEditForeground,
              tooltip: 'Edit avatar',
              onPressed: onEdit,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarContent(BuildContext context, double diameter) {
    final theme = Theme.of(context);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return AppNetworkImage(
        imageUrl: imageUrl,
        width: diameter,
        height: diameter,
      );
    }

    if (placeholder != null) {
      return placeholder!;
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: initials != null && initials!.isNotEmpty
          ? Text(
              initials!,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            )
          : Icon(AppIcons.profile, color: theme.colorScheme.onPrimaryContainer),
    );
  }
}
