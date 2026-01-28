import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_icons.dart';
import '../buttons/app_icon_button.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final PreferredSizeWidget? bottom;

  const AppAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showMenuButton = true,
    this.onMenuPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: showMenuButton
          ? IconButton(
              icon: Icon(AppIcons.menu),
              onPressed: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
              tooltip: 'Open menu',
            )
          : null,
      actions: [
        ...?actions,
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return AppIconButton(
              icon: themeProvider.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              onPressed: () => themeProvider.toggleTheme(),
              tooltip: 'Toggle theme',
            );
          },
        ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        bottom != null ? kToolbarHeight + bottom!.preferredSize.height : kToolbarHeight,
      );
}
