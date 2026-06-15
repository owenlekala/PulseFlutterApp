import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../shared/widgets/buttons/app_button.dart';
import '../../../shared/widgets/buttons/app_icon_button.dart';
import '../../../shared/widgets/cards/app_card.dart';
import '../../../shared/widgets/charts/app_bar_chart.dart';
import '../../../shared/widgets/charts/app_line_chart.dart';
import '../../../shared/widgets/charts/app_pie_chart.dart';
import '../../../shared/widgets/chips/app_filter_chip_group.dart';
import '../../../shared/widgets/chips/app_status_chip.dart';
import '../../../shared/widgets/dialogs/app_dialog.dart';
import '../../../shared/widgets/inputs/app_cupertino_date_time_field.dart';
import '../../../shared/widgets/inputs/app_dropdown.dart';
import '../../../shared/widgets/inputs/app_places_picker.dart';
import '../../../shared/widgets/inputs/app_segmented_field.dart';
import '../../../shared/widgets/inputs/app_text_field.dart';
import '../../../shared/widgets/inputs/app_toggle_field.dart';
import '../../../shared/widgets/layout/app_page_template.dart';
import '../../../shared/widgets/list/app_action_tile.dart';
import '../../../shared/widgets/list/app_slidable_list_item.dart';
import '../../../shared/widgets/loading/app_loading_indicator.dart';
import '../../../shared/widgets/loading/app_section_shimmer.dart';
import '../../../shared/widgets/loading/app_skeleton_card.dart';
import '../../../shared/widgets/loading/app_skeleton_form.dart';
import '../../../shared/widgets/maps/app_google_map.dart';
import '../../../shared/widgets/media/app_avatar.dart';
import '../../../shared/widgets/media/app_empty_image.dart';
import '../../../shared/widgets/media/app_network_image.dart';
import '../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../shared/widgets/navigation/app_drawer.dart';
import '../../../shared/widgets/navigation/app_tabs.dart';
import '../../../shared/widgets/snackbars/app_snackbar.dart';
import '../../../shared/widgets/uploads/app_upload_card.dart';
import '../../../shared/widgets/uploads/app_upload_models.dart';

enum _PreferenceSegment { driver, company, admin }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDate = DateTime.now();
  DateTime? _selectedTime = DateTime.now();
  DateTime? _selectedDateTime = DateTime.now().add(const Duration(days: 2));
  DateTimeRange? _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 4)),
  );
  bool _notificationsEnabled = true;
  _PreferenceSegment _segment = _PreferenceSegment.driver;
  Set<String> _selectedFilters = {'Pending'};
  int _currentBottomNavIndex = 0;
  String? _selectedRole = 'driver';
  List<AppUploadItem> _uploadItems = const [
    AppUploadItem(
      id: 'license',
      name: 'driver-license.pdf',
      extension: 'pdf',
      sizeBytes: 1350000,
      state: AppUploadState.uploaded,
    ),
    AppUploadItem(
      id: 'vehicle',
      name: 'vehicle-front.jpg',
      extension: 'jpg',
      sizeBytes: 2400000,
      state: AppUploadState.uploading,
      progress: 0.64,
      isPreviewable: true,
    ),
    AppUploadItem(
      id: 'insurance',
      name: 'insurance-proof.pdf',
      extension: 'pdf',
      sizeBytes: 890000,
      state: AppUploadState.failed,
      errorMessage: 'Upload interrupted. Retry from queue.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppPageTemplate(
      title: 'Shared UI Showcase',
      drawer: AppDrawer(
        userName: 'John Doe',
        userEmail: 'john.doe@example.com',
        userAvatar: const AppAvatar(
          initials: 'JD',
          radius: 28,
          showEditButton: true,
        ),
        items: [
          AppDrawerItem(
            title: 'Home',
            icon: AppIcons.home,
            isSelected: true,
            onTap: () {},
          ),
          AppDrawerItem(
            title: 'Uploads',
            icon: AppIcons.upload,
            onTap: () => AppSnackBar.showInfo(context, 'Uploads tapped'),
          ),
          AppDrawerItem(
            title: 'Settings',
            icon: AppIcons.settings,
            onTap: () => AppSnackBar.showInfo(context, 'Settings tapped'),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) => setState(() => _currentBottomNavIndex = index),
        items: const [
          AppBottomNavItem(
            label: 'Home',
            icon: AppIcons.home,
            selectedIcon: AppIcons.homeFilled,
          ),
          AppBottomNavItem(
            label: 'Search',
            icon: AppIcons.search,
            selectedIcon: AppIcons.searchFilled,
          ),
          AppBottomNavItem(
            label: 'Profile',
            icon: AppIcons.profile,
            selectedIcon: AppIcons.profileFilled,
          ),
        ],
      ),
      child: Column(
        children: [
          AppCard(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  initials: 'JD',
                  radius: 32,
                  showEditButton: true,
                  onEdit: () => AppSnackBar.showInfo(
                    context,
                    'Avatar edit action wired through shared widget.',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Shared UI System',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${AppConfig.appName} now uses a flatter shared theme with Roboto, consistent rounded inputs, and a complete home-page catalog for reusable widgets.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          AppStatusChip(
                            label: 'Roboto',
                            tone: AppStatusTone.info,
                          ),
                          AppStatusChip(
                            label: 'Rounded Inputs',
                            tone: AppStatusTone.success,
                          ),
                          AppStatusChip(
                            label: 'Low-Shadow UI',
                            tone: AppStatusTone.warning,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSection(context, 'Inputs', [
            AppTextField(
              label: 'Full name',
              hint: 'Enter passenger or driver name',
              prefixIcon: const Icon(Icons.badge_outlined),
              helperText: 'Shared inline validation and consistent corners.',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Full name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppDropdown<String>(
              label: 'Role',
              hint: 'Choose a role',
              value: _selectedRole,
              prefixIcon: const Icon(Icons.account_tree_outlined),
              items: const [
                DropdownMenuItem(value: 'driver', child: Text('Driver')),
                DropdownMenuItem(
                  value: 'dispatcher',
                  child: Text('Dispatcher'),
                ),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Role is required';
                }
                return null;
              },
              onChanged: (value) => setState(() => _selectedRole = value),
            ),
            const SizedBox(height: 16),
            AppDateField(
              label: 'Pickup date',
              value: _selectedDate,
              minimumDate: DateTime.now().subtract(const Duration(days: 1)),
              maximumDate: DateTime.now().add(const Duration(days: 90)),
              helperText: 'Cupertino bottom-sheet date picker.',
              onChanged: (value) => setState(() => _selectedDate = value),
            ),
            const SizedBox(height: 16),
            AppTimeField(
              label: 'Pickup time',
              value: _selectedTime,
              use24hFormat: true,
              minuteInterval: 5,
              onChanged: (value) => setState(() => _selectedTime = value),
            ),
            const SizedBox(height: 16),
            AppDateTimeField(
              label: 'Inspection slot',
              value: _selectedDateTime,
              use24hFormat: true,
              minuteInterval: 15,
              onChanged: (value) => setState(() => _selectedDateTime = value),
            ),
            const SizedBox(height: 16),
            AppDateRangeField(
              label: 'Trip range',
              value: _selectedDateRange,
              helperText: 'Shared range selector for bookings and reports.',
              onChanged: (value) => setState(() => _selectedDateRange = value),
            ),
            const SizedBox(height: 16),
            AppToggleField(
              title: 'Push notifications',
              subtitle: 'Enable reminders for document expiry and trip status.',
              value: _notificationsEnabled,
              leading: Icon(
                AppIcons.notification,
                color: theme.colorScheme.primary,
              ),
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            const SizedBox(height: 16),
            AppSegmentedField<_PreferenceSegment>(
              label: 'Default persona',
              value: _segment,
              options: const [
                AppSegmentOption(
                  value: _PreferenceSegment.driver,
                  label: 'Driver',
                  icon: AppIcons.navigation,
                ),
                AppSegmentOption(
                  value: _PreferenceSegment.company,
                  label: 'Company',
                  icon: AppIcons.folder,
                ),
                AppSegmentOption(
                  value: _PreferenceSegment.admin,
                  label: 'Admin',
                  icon: AppIcons.settings,
                ),
              ],
              onChanged: (value) => setState(() => _segment = value),
            ),
            const SizedBox(height: 16),
            AppPlacesPicker(
              label: 'Pickup location',
              hint: 'Search for a place',
              onPlaceSelected: (_) {
                AppSnackBar.showInfo(context, 'Place selected');
              },
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Buttons + Feedback', [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppButton(
                  text: 'Primary',
                  onPressed: () =>
                      AppSnackBar.showSuccess(context, 'Primary button tapped'),
                ),
                AppButton(
                  text: 'Secondary',
                  type: AppButtonType.secondary,
                  onPressed: () =>
                      AppSnackBar.showInfo(context, 'Secondary button tapped'),
                ),
                AppButton(
                  text: 'Outlined',
                  type: AppButtonType.outlined,
                  onPressed: () => AppSnackBar.showWarning(
                    context,
                    'Outlined button tapped',
                  ),
                ),
                AppButton(
                  text: 'Text',
                  type: AppButtonType.text,
                  onPressed: () =>
                      AppSnackBar.showInfo(context, 'Text button tapped'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppIconButton(
                  icon: AppIcons.refresh,
                  tooltip: 'Refresh',
                  onPressed: () =>
                      AppSnackBar.showInfo(context, 'Refresh icon button'),
                ),
                AppIconButton(
                  icon: AppIcons.filter,
                  tooltip: 'Filter',
                  onPressed: () =>
                      AppSnackBar.showInfo(context, 'Filter icon button'),
                ),
                AppIconButton(
                  icon: AppIcons.settings,
                  tooltip: 'Settings',
                  onPressed: () =>
                      AppSnackBar.showInfo(context, 'Settings icon button'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Row(
                children: const [
                  Expanded(
                    child: AppLoadingIndicator(message: 'Loading shared state'),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: AppLoadingIndicator(type: AppLoadingType.linear),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppButton(
                  text: 'Dialog',
                  onPressed: () {
                    AppDialog.show(
                      context: context,
                      title: 'Shared Dialog',
                      message:
                          'Dialogs follow the same corners, typography, and button system.',
                      icon: AppIcons.info,
                    );
                  },
                ),
                AppButton(
                  text: 'Success Toast',
                  type: AppButtonType.outlined,
                  onPressed: () => AppSnackBar.showSuccess(
                    context,
                    'Shared success feedback',
                  ),
                ),
                AppButton(
                  text: 'Error Toast',
                  type: AppButtonType.outlined,
                  onPressed: () =>
                      AppSnackBar.showError(context, 'Shared error feedback'),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Media + Cards', [
            Row(
              children: [
                AppAvatar(
                  initials: 'KM',
                  radius: 30,
                  showEditButton: true,
                  onEdit: () =>
                      AppSnackBar.showInfo(context, 'Edit avatar tapped'),
                ),
                const SizedBox(width: 16),
                const AppNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
                  width: 84,
                  height: 84,
                ),
                const SizedBox(width: 16),
                const AppEmptyImage(size: 84, message: 'Empty state'),
              ],
            ),
            const SizedBox(height: 16),
            AppCard(
              onTap: () =>
                  AppSnackBar.showInfo(context, 'Reusable card tapped'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reusable Card', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Cards now use borders instead of shadows for a cleaner, flatter system.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Tabs + Charts', [
            AppTabs(
              height: 420,
              tabs: const [
                AppTabItem(label: 'Line'),
                AppTabItem(label: 'Bar'),
                AppTabItem(label: 'Pie'),
              ],
              children: [
                SingleChildScrollView(
                  child: AppLineChart(
                    title: 'Trips completed',
                    leftTitle: 'Count',
                    bottomTitle: 'Day',
                    spots: const [
                      FlSpot(1, 2),
                      FlSpot(2, 4),
                      FlSpot(3, 3),
                      FlSpot(4, 5),
                      FlSpot(5, 7),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: AppBarChart(
                    title: 'Weekly earnings',
                    leftTitle: 'R',
                    bottomLabels: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
                    barGroups: [
                      _barGroup(0, 3),
                      _barGroup(1, 5),
                      _barGroup(2, 4),
                      _barGroup(3, 7),
                      _barGroup(4, 6),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: AppPieChart(
                    title: 'Trip status mix',
                    radius: 64,
                    data: [
                      AppPieChartData(
                        label: 'Done',
                        value: 58,
                        color: AppColors.successLight,
                      ),
                      AppPieChartData(
                        label: 'Pending',
                        value: 27,
                        color: AppColors.warningLight,
                      ),
                      AppPieChartData(
                        label: 'Issues',
                        value: 15,
                        color: AppColors.errorLight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Maps + Routing', [
            AppCard(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                height: 260,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AppGoogleMap(
                    latitude: -26.2041,
                    longitude: 28.0473,
                    zoom: 11,
                    pins: const [
                      AppMapPin(
                        id: 'origin',
                        position: LatLng(-26.2041, 28.0473),
                        title: 'Origin',
                        hue: BitmapDescriptor.hueAzure,
                      ),
                      AppMapPin(
                        id: 'stop',
                        position: LatLng(-26.1700, 28.0400),
                        title: 'Checkpoint',
                        hue: BitmapDescriptor.hueOrange,
                      ),
                      AppMapPin(
                        id: 'destination',
                        position: LatLng(-26.1300, 28.0500),
                        title: 'Destination',
                        hue: BitmapDescriptor.hueGreen,
                      ),
                    ],
                    routeLines: const [
                      AppMapRouteLine(
                        id: 'route-a',
                        color: AppColors.primaryLight,
                        points: [
                          LatLng(-26.2041, 28.0473),
                          LatLng(-26.1700, 28.0400),
                          LatLng(-26.1300, 28.0500),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Uploads', [
            AppUploadCard(
              title: 'Driver documents',
              subtitle:
                  'Shared upload surface for license, insurance, and vehicle media.',
              source: AppUploadSource.mixed,
              state: AppUploadState.uploading,
              items: _uploadItems,
              onTap: () {
                AppSnackBar.showInfo(context, 'Connect picker/use-case here');
              },
              onPreviewItem: (item) {
                AppSnackBar.showInfo(context, 'Preview ${item.name}');
              },
              onRetryItem: (item) {
                setState(() {
                  _uploadItems = _uploadItems
                      .map(
                        (candidate) => candidate.id == item.id
                            ? AppUploadItem(
                                id: candidate.id,
                                name: candidate.name,
                                extension: candidate.extension,
                                sizeBytes: candidate.sizeBytes,
                                progress: 0.3,
                                state: AppUploadState.uploading,
                                isPreviewable: candidate.isPreviewable,
                              )
                            : candidate,
                      )
                      .toList();
                });
              },
              onRemoveItem: (item) {
                setState(() {
                  _uploadItems = _uploadItems
                      .where((candidate) => candidate.id != item.id)
                      .toList();
                });
              },
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Loading + Filters', [
            const AppSkeletonCard(height: 120),
            const SizedBox(height: 16),
            const AppSkeletonForm(fieldCount: 3),
            const SizedBox(height: 16),
            AppSectionShimmer(
              enabled: true,
              child: AppFilterChipGroup<String>(
                options: const [
                  AppFilterChipOption(value: 'Pending', label: 'Pending'),
                  AppFilterChipOption(value: 'Verified', label: 'Verified'),
                  AppFilterChipOption(value: 'Rejected', label: 'Rejected'),
                ],
                selectedValues: _selectedFilters,
                onChanged: (value) => setState(() => _selectedFilters = value),
              ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection(context, 'Action Lists', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                AppStatusChip(label: 'Active', tone: AppStatusTone.success),
                AppStatusChip(label: 'Queued', tone: AppStatusTone.warning),
                AppStatusChip(label: 'Blocked', tone: AppStatusTone.error),
                AppStatusChip(label: 'Info', tone: AppStatusTone.info),
              ],
            ),
            const SizedBox(height: 16),
            AppSlidableListItem(
              endActions: [
                AppSlidableActionItem(
                  label: 'Archive',
                  icon: AppIcons.bookmark,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.primary,
                  onPressed: () {
                    AppSnackBar.showInfo(context, 'Archive action');
                  },
                ),
                AppSlidableActionItem(
                  label: 'Delete',
                  icon: AppIcons.delete,
                  backgroundColor: theme.colorScheme.errorContainer,
                  foregroundColor: theme.colorScheme.error,
                  onPressed: () {
                    AppSnackBar.showError(context, 'Delete action');
                  },
                ),
              ],
              child: AppActionTile(
                leading: const AppAvatar(initials: 'KM'),
                title: 'Pending compliance review',
                subtitle: 'Swipe left for archive/delete actions.',
                trailing: const Icon(Icons.chevron_right),
                onTap: () => AppSnackBar.showInfo(context, 'Tile tapped'),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  static BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 18,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
