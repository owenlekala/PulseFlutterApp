import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppSlidableActionItem {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  const AppSlidableActionItem({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });
}

class AppSlidableListItem extends StatelessWidget {
  final Widget child;
  final List<AppSlidableActionItem> startActions;
  final List<AppSlidableActionItem> endActions;

  const AppSlidableListItem({
    super.key,
    required this.child,
    this.startActions = const [],
    this.endActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (startActions.isEmpty && endActions.isEmpty) {
      return child;
    }

    return Slidable(
      startActionPane: startActions.isEmpty
          ? null
          : ActionPane(
              motion: const DrawerMotion(),
              children: startActions
                  .map((action) => _buildAction(context, action))
                  .toList(),
            ),
      endActionPane: endActions.isEmpty
          ? null
          : ActionPane(
              motion: const StretchMotion(),
              children: endActions
                  .map((action) => _buildAction(context, action))
                  .toList(),
            ),
      child: child,
    );
  }

  Widget _buildAction(BuildContext context, AppSlidableActionItem action) {
    return SlidableAction(
      onPressed: (_) => action.onPressed(),
      label: action.label,
      icon: action.icon,
      backgroundColor: action.backgroundColor,
      foregroundColor: action.foregroundColor,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
