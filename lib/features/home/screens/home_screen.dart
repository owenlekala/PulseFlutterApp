import 'package:flutter/material.dart';

import '../../../core/utils/app_icons.dart';
import '../../../shared/widgets/media/app_avatar.dart';
import '../../../shared/widgets/navigation/app_app_bar.dart';
import '../../../shared/widgets/navigation/app_bottom_navigation_bar.dart';
import '../../../shared/widgets/navigation/app_drawer.dart';
import '../../activity/presentation/pages/activity_page.dart';
import '../../dashboard/presentation/pages/dashboard_page.dart';
import '../../profile/presentation/pages/profile_settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _titles = ['Today', 'My activity', 'Profile & settings'];

  void _selectPage(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: _titles[_currentIndex],
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {},
            icon: const Icon(AppIcons.notification),
          ),
        ],
      ),
      drawer: AppDrawer(
        userName: 'Maya Johnson',
        userEmail: 'maya.johnson@example.com',
        userAvatar: const AppAvatar(initials: 'MJ', radius: 30),
        onProfileTap: () => _selectPage(2),
        items: [
          AppDrawerItem(
            title: 'Today',
            icon: AppIcons.home,
            isSelected: _currentIndex == 0,
            onTap: () => _selectPage(0),
          ),
          AppDrawerItem(
            title: 'My activity',
            icon: AppIcons.chart,
            isSelected: _currentIndex == 1,
            onTap: () => _selectPage(1),
          ),
          AppDrawerItem(
            title: 'Profile & settings',
            icon: AppIcons.settings,
            isSelected: _currentIndex == 2,
            onTap: () => _selectPage(2),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashboardPage(),
          ActivityPage(),
          ProfileSettingsPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectPage,
        items: const [
          AppBottomNavItem(
            label: 'Today',
            icon: AppIcons.home,
            selectedIcon: AppIcons.homeFilled,
          ),
          AppBottomNavItem(
            label: 'Activity',
            icon: Icons.insights_outlined,
            selectedIcon: Icons.insights_rounded,
          ),
          AppBottomNavItem(
            label: 'Profile',
            icon: AppIcons.profile,
            selectedIcon: AppIcons.profileFilled,
          ),
        ],
      ),
    );
  }
}
