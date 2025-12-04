import '../utils/env_loader.dart';
import 'environment.dart';

class ApiConfig {
  static String get baseUrl {
    final env = Environment.current;
    final envBaseUrl = EnvLoader.get('API_BASE_URL');
    
    if (envBaseUrl.isNotEmpty) {
      return envBaseUrl;
    }

    // Fallback URLs based on environment
    switch (env) {
      case Environment.dev:
        return 'https://api-dev.example.com';
      case Environment.staging:
        return 'https://api-staging.example.com';
      case Environment.production:
        return 'https://api.example.com';
    }
  }

  static String get apiVersion => EnvLoader.get('API_VERSION', defaultValue: 'v1');
  
  static String get fullBaseUrl => '$baseUrl/$apiVersion';

  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
  static Duration get sendTimeout => const Duration(seconds: 30);

  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}

