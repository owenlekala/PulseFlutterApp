import '../utils/env_loader.dart';
import 'environment.dart';

class AppConfig {
  static String get appName => 'App Template';
  static String get appVersion => EnvLoader.get('APP_VERSION', defaultValue: '1.0.0');
  static String get buildNumber => EnvLoader.get('APP_BUILD_NUMBER', defaultValue: '1');
  
  static Environment get environment {
    final envString = EnvLoader.get('APP_ENV', defaultValue: 'dev');
    return Environment.fromString(envString);
  }

  static String get googleMapsApiKeyAndroid =>
      EnvLoader.get('GOOGLE_MAPS_API_KEY_ANDROID');
  static String get googleMapsApiKeyIOS =>
      EnvLoader.get('GOOGLE_MAPS_API_KEY_IOS');

  // App settings
  static bool get enableLogging => !environment.isProduction;
  static bool get enableCrashReporting => environment.isProduction;

  // Feature flags
  static bool get enableAnalytics => true;
  static bool get enablePushNotifications => true;
}

