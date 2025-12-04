import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class EnvLoader {
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } on PlatformException catch (e) {
      throw Exception('Error loading .env file: ${e.message}');
    } catch (e) {
      throw Exception('Error loading .env file: $e');
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

