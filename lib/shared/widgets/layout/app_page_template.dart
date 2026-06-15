import 'package:flutter/material.dart';

import '../navigation/app_app_bar.dart';

class AppPageTemplate extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final PreferredSizeWidget? bottom;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final bool scrollable;
  final bool resizeToAvoidBottomInset;

  const AppPageTemplate({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.showMenuButton = true,
    this.onMenuPressed,
    this.bottom,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.scrollable = true,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = scrollable
        ? ListView(padding: padding, children: [child])
        : Padding(padding: padding, child: child);

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor,
      appBar: AppAppBar(
        title: title,
        actions: actions,
        showMenuButton: showMenuButton,
        onMenuPressed: onMenuPressed,
        bottom: bottom,
      ),
      drawer: drawer,
      endDrawer: endDrawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: SafeArea(top: false, child: body),
    );
  }
}
