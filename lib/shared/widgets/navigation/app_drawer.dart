import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../buttons/app_icon_button.dart';

class AppDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final Widget? userAvatar;
  final List<AppDrawerItem> items;
  final VoidCallback? onProfileTap;

  const AppDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.userAvatar,
    required this.items,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Drawer(
      child: Column(
        children: [
          // User Header Section
          if (userName != null || userEmail != null || userAvatar != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: InkWell(
                onTap: onProfileTap,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userAvatar != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: userAvatar!,
                      )
                    else
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          AppIcons.profile,
                          size: 32,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    if (userName != null)
                      Text(
                        userName!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (userEmail != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        userEmail!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _DrawerItemWidget(
                  item: item,
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap?.call();
                  },
                );
              },
            ),
          ),

          // Footer Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.getBorder(brightness),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? iconColor;
  final Color? textColor;

  const AppDrawerItem({
    required this.title,
    required this.icon,
    this.onTap,
    this.isSelected = false,
    this.iconColor,
    this.textColor,
  });
}

class _DrawerItemWidget extends StatelessWidget {
  final AppDrawerItem item;
  final VoidCallback onTap;

  const _DrawerItemWidget({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = item.isSelected;

    return ListTile(
      leading: Icon(
        item.icon,
        color: item.iconColor ??
            (isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant),
      ),
      title: Text(
        item.title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: item.textColor ??
              (isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
      onTap: item.onTap != null ? onTap : null,
    );
  }
}
