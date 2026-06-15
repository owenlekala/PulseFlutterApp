import 'package:flutter/material.dart';

import '../../../../core/utils/app_icons.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/chips/app_filter_chip_group.dart';
import '../../../../shared/widgets/chips/app_status_chip.dart';
import '../../../../shared/widgets/inputs/app_cupertino_date_time_field.dart';
import '../../../../shared/widgets/inputs/app_dropdown.dart';
import '../../../../shared/widgets/list/app_action_tile.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  Set<String> _filters = {'All'};
  String? _category = 'movement';
  DateTime _planDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Your weekly rhythm', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'Plan healthy routines and review completed sessions.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        AppFilterChipGroup<String>(
          options: const [
            AppFilterChipOption(value: 'All', label: 'All'),
            AppFilterChipOption(value: 'Planned', label: 'Planned'),
            AppFilterChipOption(value: 'Completed', label: 'Completed'),
          ],
          selectedValues: _filters,
          onChanged: (values) => setState(() => _filters = values),
        ),
        const SizedBox(height: 20),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a plan', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              AppDropdown<String>(
                label: 'Activity type',
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'movement', child: Text('Movement')),
                  DropdownMenuItem(
                    value: 'mindfulness',
                    child: Text('Mindfulness'),
                  ),
                  DropdownMenuItem(
                    value: 'nutrition',
                    child: Text('Nutrition'),
                  ),
                  DropdownMenuItem(value: 'recovery', child: Text('Recovery')),
                ],
                onChanged: (value) => setState(() => _category = value),
              ),
              const SizedBox(height: 16),
              AppDateField(
                label: 'Plan date',
                value: _planDate,
                minimumDate: DateTime.now(),
                onChanged: (value) => setState(() => _planDate = value),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Add to my plan',
                icon: const Icon(AppIcons.add),
                isFullWidth: true,
                onPressed: () => AppSnackBar.showSuccess(
                  context,
                  'Activity added to your plan',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Text('This week', style: theme.textTheme.titleLarge),
            ),
            const AppStatusChip(label: '4 sessions', tone: AppStatusTone.info),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppActionTile(
                leading: const _ActivityIcon(
                  icon: Icons.directions_run_rounded,
                ),
                title: 'Easy morning run',
                subtitle: 'Today · 07:00 · 30 min',
                trailing: const AppStatusChip(
                  label: 'Done',
                  tone: AppStatusTone.success,
                ),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 72),
              AppActionTile(
                leading: const _ActivityIcon(
                  icon: Icons.self_improvement_rounded,
                ),
                title: 'Guided breathing',
                subtitle: 'Tomorrow · 08:30 · 10 min',
                trailing: const AppStatusChip(
                  label: 'Planned',
                  tone: AppStatusTone.warning,
                ),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 72),
              AppActionTile(
                leading: const _ActivityIcon(icon: Icons.restaurant_rounded),
                title: 'Meal prep',
                subtitle: 'Saturday · 16:00 · 45 min',
                trailing: const Icon(AppIcons.forward),
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  final IconData icon;

  const _ActivityIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      backgroundColor: theme.colorScheme.secondaryContainer,
      child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
    );
  }
}
