import 'package:flutter/material.dart';

import '../../../../core/utils/app_icons.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/chips/app_status_chip.dart';
import '../../../../shared/widgets/list/app_action_tile.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Good morning, Maya', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'A steady day starts with one small win.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        AppCard(
          color: theme.colorScheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Daily readiness',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const AppStatusChip(
                    label: 'On track',
                    tone: AppStatusTone.success,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '82%',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.82,
                minHeight: 8,
                borderRadius: BorderRadius.circular(99),
              ),
              const SizedBox(height: 16),
              Text(
                'You slept well and have completed two of today\'s goals.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Today\'s goals', action: 'View all'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.directions_walk_rounded,
                value: '6,420',
                label: 'Steps',
                progress: 0.64,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.water_drop_outlined,
                value: '5 / 8',
                label: 'Glasses',
                progress: 0.62,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.bedtime_outlined,
                value: '7h 42m',
                label: 'Sleep',
                progress: 0.86,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.self_improvement_rounded,
                value: '12 min',
                label: 'Mindful',
                progress: 0.48,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const _SectionHeader(title: 'Up next', action: 'Schedule'),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppActionTile(
                leading: const _IconBadge(icon: Icons.fitness_center_rounded),
                title: 'Strength session',
                subtitle: '12:30 · 35 minutes',
                trailing: const AppStatusChip(
                  label: 'Today',
                  tone: AppStatusTone.info,
                ),
                onTap: () => AppSnackBar.showInfo(
                  context,
                  'Strength session details opened',
                ),
              ),
              const Divider(height: 1, indent: 72),
              AppActionTile(
                leading: const _IconBadge(icon: Icons.restaurant_rounded),
                title: 'Log lunch',
                subtitle: 'Aim for a balanced plate',
                trailing: const Icon(AppIcons.forward),
                onTap: () =>
                    AppSnackBar.showInfo(context, 'Meal logger opened'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppButton(
          text: 'Start a quick check-in',
          icon: const Icon(Icons.add_reaction_outlined),
          isFullWidth: true,
          onPressed: () =>
              AppSnackBar.showSuccess(context, 'Daily check-in started'),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;

  const _SectionHeader({required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        TextButton(onPressed: () {}, child: Text(action)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double progress;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(height: 18),
          Text(value, style: theme.textTheme.titleLarge),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            borderRadius: BorderRadius.circular(99),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;

  const _IconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
