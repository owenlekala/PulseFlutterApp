import 'package:flutter/material.dart';

import '../../../../core/utils/app_icons.dart';
import '../../../../shared/widgets/buttons/app_button.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/dialogs/app_dialog.dart';
import '../../../../shared/widgets/inputs/app_dropdown.dart';
import '../../../../shared/widgets/inputs/app_toggle_field.dart';
import '../../../../shared/widgets/list/app_action_tile.dart';
import '../../../../shared/widgets/media/app_avatar.dart';
import '../../../../shared/widgets/snackbars/app_snackbar.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  bool _dailyReminder = true;
  bool _weeklySummary = true;
  bool _healthSync = false;
  String? _language = 'English';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        AppCard(
          child: Column(
            children: [
              AppAvatar(
                initials: 'MJ',
                radius: 46,
                showEditButton: true,
                onEdit: () => AppSnackBar.showInfo(
                  context,
                  'Profile photo picker opened',
                ),
              ),
              const SizedBox(height: 16),
              Text('Maya Johnson', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'maya.johnson@example.com',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Edit profile',
                type: AppButtonType.outlined,
                icon: const Icon(AppIcons.edit),
                onPressed: () => _showEditProfile(context),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SettingsHeader(title: 'Account'),
        const SizedBox(height: 8),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppActionTile(
                leading: const Icon(AppIcons.profile),
                title: 'Personal information',
                subtitle: 'Name, email and phone number',
                trailing: const Icon(AppIcons.forward),
                onTap: () => _showEditProfile(context),
              ),
              const Divider(height: 1, indent: 56),
              AppActionTile(
                leading: const Icon(AppIcons.lock),
                title: 'Privacy and security',
                subtitle: 'Password and data controls',
                trailing: const Icon(AppIcons.forward),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SettingsHeader(title: 'Preferences'),
        const SizedBox(height: 8),
        AppToggleField(
          title: 'Daily reminders',
          subtitle: 'A gentle prompt to complete your goals',
          leading: const Icon(AppIcons.notification),
          value: _dailyReminder,
          onChanged: (value) => setState(() => _dailyReminder = value),
        ),
        const SizedBox(height: 12),
        AppToggleField(
          title: 'Weekly progress summary',
          subtitle: 'Receive your report every Sunday',
          leading: const Icon(Icons.insights_outlined),
          value: _weeklySummary,
          onChanged: (value) => setState(() => _weeklySummary = value),
        ),
        const SizedBox(height: 12),
        AppToggleField(
          title: 'Sync health data',
          subtitle: 'Connect activity data from your device',
          leading: const Icon(AppIcons.heart),
          value: _healthSync,
          onChanged: (value) => setState(() => _healthSync = value),
        ),
        const SizedBox(height: 16),
        AppDropdown<String>(
          label: 'Language',
          value: _language,
          prefixIcon: const Icon(Icons.language_rounded),
          items: const [
            DropdownMenuItem(value: 'English', child: Text('English')),
            DropdownMenuItem(value: 'French', child: Text('French')),
            DropdownMenuItem(value: 'Portuguese', child: Text('Portuguese')),
            DropdownMenuItem(value: 'Zulu', child: Text('Zulu')),
          ],
          onChanged: (value) => setState(() => _language = value),
        ),
        const SizedBox(height: 24),
        const _SettingsHeader(title: 'Support'),
        const SizedBox(height: 8),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              AppActionTile(
                leading: const Icon(AppIcons.info),
                title: 'Help center',
                trailing: const Icon(AppIcons.forward),
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56),
              AppActionTile(
                leading: const Icon(AppIcons.message),
                title: 'Send feedback',
                trailing: const Icon(AppIcons.forward),
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          text: 'Sign out',
          type: AppButtonType.outlined,
          isFullWidth: true,
          foregroundColor: theme.colorScheme.error,
          onPressed: () => AppConfirmDialog.show(
            context: context,
            title: 'Sign out?',
            message: 'You can sign back in at any time.',
            confirmText: 'Sign out',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Pulse version 1.0.0',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Future<void> _showEditProfile(BuildContext context) {
    return AppDialog.show(
      context: context,
      title: 'Edit profile',
      confirmText: 'Save',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: InputDecoration(labelText: 'Full name')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'Email address')),
        ],
      ),
      onConfirm: () {
        Navigator.pop(context);
        AppSnackBar.showSuccess(context, 'Profile updated');
      },
    ).then((_) {});
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
