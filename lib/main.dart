import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/firebase_config.dart';
import 'core/utils/env_loader.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/error/error_handler_setup.dart';
import 'core/error/error_boundary.dart';
import 'shared/widgets/connectivity/no_internet_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup global error handling
  ErrorHandlerSetup.setup();

  // Load environment variables
  try {
    await EnvLoader.load();
  } catch (e) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Initialize Firebase
  try {
    await FirebaseConfig.initialize();
  } catch (e) {
    debugPrint('Warning: Could not initialize Firebase: $e');
  }

  // Initialize SharedPreferences for theme persistence
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ErrorBoundary(
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(prefs),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return ConnectivityWrapper(
          child: MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getLightTheme(),
            darkTheme: AppTheme.getDarkTheme(),
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
