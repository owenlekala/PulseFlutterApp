import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_icons.dart';
import '../../../core/config/app_config.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/buttons/app_icon_button.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/app_date_picker.dart';
import '../../../shared/widgets/inputs/app_time_picker.dart';
import '../../../shared/widgets/inputs/app_places_picker.dart';
import '../../../shared/widgets/loading/app_loading_indicator.dart';
import '../../../shared/widgets/snackbars/app_snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ${AppConfig.appName}',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is your home screen. Start building your features here!',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Environment: ${AppConfig.environment.value}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Input Widgets Showcase
            _buildSection(
              context,
              title: 'Input Widgets',
              children: [
                _buildWidgetCard(
                  context,
                  title: 'Text Field',
                  icon: AppIcons.edit,
                  onTap: () => _showTextFieldExample(context),
                ),
                _buildWidgetCard(
                  context,
                  title: 'Date Picker',
                  icon: AppIcons.calendar,
                  onTap: () => _showDatePickerExample(context),
                ),
                _buildWidgetCard(
                  context,
                  title: 'Time Picker',
                  icon: AppIcons.clock,
                  onTap: () => _showTimePickerExample(context),
                ),
                _buildWidgetCard(
                  context,
                  title: 'Places Picker',
                  icon: AppIcons.location,
                  onTap: () => _showPlacesPickerExample(context),
                ),
              ],
            ),

            // Button Widgets Showcase
            _buildSection(
              context,
              title: 'Button Widgets',
              children: [
                AppButton(
                  text: 'Primary Button',
                  type: AppButtonType.primary,
                  onPressed: () => _showButtonExample(context, 'Primary'),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Secondary Button',
                  type: AppButtonType.secondary,
                  onPressed: () => _showButtonExample(context, 'Secondary'),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Outlined Button',
                  type: AppButtonType.outlined,
                  onPressed: () => _showButtonExample(context, 'Outlined'),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Text Button',
                  type: AppButtonType.text,
                  onPressed: () => _showButtonExample(context, 'Text'),
                  isFullWidth: true,
                ),
              ],
            ),

            // Loading Widgets Showcase
            _buildSection(
              context,
              title: 'Loading Widgets',
              children: [
                AppCard(
                  child: Column(
                    children: [
                      const AppLoadingIndicator(
                        type: AppLoadingType.circular,
                        message: 'Circular Loading',
                      ),
                      const SizedBox(height: 24),
                      const AppLoadingIndicator(
                        type: AppLoadingType.linear,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Snackbar Widgets Showcase
            _buildSection(
              context,
              title: 'Snackbar Widgets',
              children: [
                AppButton(
                  text: 'Show Success Snackbar',
                  type: AppButtonType.primary,
                  onPressed: () => AppSnackBar.showSuccess(
                    context,
                    'Operation completed successfully!',
                  ),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Show Error Snackbar',
                  type: AppButtonType.primary,
                  onPressed: () => AppSnackBar.showError(
                    context,
                    'Something went wrong. Please try again.',
                  ),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Show Warning Snackbar',
                  type: AppButtonType.primary,
                  onPressed: () => AppSnackBar.showWarning(
                    context,
                    'Please check your input before proceeding.',
                  ),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Show Info Snackbar',
                  type: AppButtonType.primary,
                  onPressed: () => AppSnackBar.showInfo(
                    context,
                    'New features are available. Check them out!',
                  ),
                  isFullWidth: true,
                ),
                const SizedBox(height: 8),
                AppButton(
                  text: 'Show Snackbar with Action',
                  type: AppButtonType.primary,
                  onPressed: () => AppSnackBar.showSuccess(
                    context,
                    'Item deleted successfully',
                    actionLabel: 'Undo',
                    onAction: () {
                      AppSnackBar.showInfo(context, 'Action undone');
                    },
                  ),
                  isFullWidth: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...children,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildWidgetCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return AppCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 32,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  void _showTextFieldExample(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Field Example'),
        content: AppTextField(
          label: 'Email',
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(AppIcons.email),
        ),
        actions: [
          AppButton(
            text: 'Close',
            type: AppButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showDatePickerExample(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Date Picker Example'),
        content: StatefulBuilder(
          builder: (context, setState) => AppDatePicker(
            label: 'Select Date',
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ),
        actions: [
          AppButton(
            text: 'Close',
            type: AppButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showTimePickerExample(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Picker Example'),
        content: StatefulBuilder(
          builder: (context, setState) => AppTimePicker(
            label: 'Select Time',
            selectedTime: _selectedTime,
            onTimeSelected: (time) {
              setState(() {
                _selectedTime = time;
              });
            },
          ),
        ),
        actions: [
          AppButton(
            text: 'Close',
            type: AppButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showPlacesPickerExample(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Places Picker Example'),
        content: StatefulBuilder(
          builder: (context, setState) => AppPlacesPicker(
            label: 'Search Location',
            onPlaceSelected: (prediction) {
              AppSnackBar.showSuccess(
                context,
                'Selected: ${prediction.description}',
              );
            },
          ),
        ),
        actions: [
          AppButton(
            text: 'Close',
            type: AppButtonType.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showButtonExample(BuildContext context, String type) {
    AppSnackBar.showInfo(
      context,
      '$type button pressed',
    );
  }
}
