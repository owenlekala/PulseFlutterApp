import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class EnvLoader {
  static Future<void> load() async {
    final fileName = _resolveEnvFileName();

    try {
      await dotenv.load(fileName: fileName);
    } on PlatformException catch (e) {
      throw Exception(
        'Error loading environment file "$fileName": ${e.message}',
      );
    } catch (e) {
      throw Exception('Error loading environment file "$fileName": $e');
    }
  }

  static String _resolveEnvFileName() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

    switch (env) {
      case 'development':
      case 'dev':
        return '.env.development';
      case 'staging':
        return '.env.staging';
      case 'production':
      case 'prod':
        return '.env.production';
      default:
        return '.env';
    }
  }

  static String get(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return value.toLowerCase() == 'true';
  }

  static int getInt(String key, {int defaultValue = 0}) {
    final value = dotenv.env[key];
    if (value == null) return defaultValue;
    return int.tryParse(value) ?? defaultValue;
  }
}
