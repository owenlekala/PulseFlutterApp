import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_extensions.dart';

class AppTabItem {
  final String label;
  final Widget? icon;
  final Widget? badge;

  const AppTabItem({required this.label, this.icon, this.badge});
}

enum AppTabsStyle { underline, pill }

class AppTabs extends StatelessWidget {
  final List<AppTabItem> tabs;
  final List<Widget> children;
  final AppTabsStyle style;
  final double? height;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int>? onTap;
  final TabController? controller;
  final bool isScrollable;

  const AppTabs({
    super.key,
    required this.tabs,
    required this.children,
    this.style = AppTabsStyle.pill,
    this.height,
    this.padding = const EdgeInsets.all(2),
    this.onTap,
    this.controller,
    this.isScrollable = false,
  }) : assert(tabs.length == children.length);

  @override
  Widget build(BuildContext context) {
    if (controller != null) {
      return _AppTabsContent(
        tabs: tabs,
        style: style,
        height: height,
        padding: padding,
        onTap: onTap,
        controller: controller!,
        isScrollable: isScrollable,
        children: children,
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          return _AppTabsContent(
            tabs: tabs,
            style: style,
            height: height,
            padding: padding,
            onTap: onTap,
            controller: DefaultTabController.of(context),
            isScrollable: isScrollable,
            children: children,
          );
        },
      ),
    );
  }
}

class _AppTabsContent extends StatelessWidget {
  final List<AppTabItem> tabs;
  final List<Widget> children;
  final AppTabsStyle style;
  final double? height;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int>? onTap;
  final TabController controller;
  final bool isScrollable;

  const _AppTabsContent({
    required this.tabs,
    required this.children,
    required this.style,
    required this.height,
    required this.padding,
    required this.onTap,
    required this.controller,
    required this.isScrollable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.appColors;
    final isPill = style == AppTabsStyle.pill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isPill ? appColors.tabBarBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TabBar(
            controller: controller,
            isScrollable: isScrollable,
            onTap: onTap,
            dividerColor: Colors.transparent,
            splashBorderRadius: BorderRadius.circular(10),
            indicatorSize: TabBarIndicatorSize.tab,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            labelColor: appColors.tabBarForeground,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            labelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0,
            ),
            unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              letterSpacing: 0,
            ),
            indicator: isPill
                ? BoxDecoration(
                    color: appColors.tabBarIndicator,
                    borderRadius: BorderRadius.circular(10),
                  )
                : UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: appColors.tabBarIndicator,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
            tabs: tabs.map(_buildTab).toList(),
          ),
        ),
        SizedBox(
          height: height,
          child: TabBarView(controller: controller, children: children),
        ),
      ],
    );
  }

  Widget _buildTab(AppTabItem item) {
    final label = Text(item.label);

    if (item.icon == null && item.badge == null) {
      return Tab(height: 32, text: item.label);
    }

    return Tab(
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.icon != null) ...[item.icon!, const SizedBox(width: 8)],
          label,
          if (item.badge != null) ...[const SizedBox(width: 8), item.badge!],
        ],
      ),
    );
  }
}
