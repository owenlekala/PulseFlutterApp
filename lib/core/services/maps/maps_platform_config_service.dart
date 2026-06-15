import 'package:flutter/services.dart';

class MapsPlatformConfigService {
  static const MethodChannel _channel = MethodChannel(
    'app_template/maps_platform_config',
  );

  static const String _placeholderPrefix = 'YOUR_';

  static Future<bool> isGoogleMapsConfigured() async {
    try {
      final configured = await _channel.invokeMethod<bool>(
        'isGoogleMapsConfigured',
      );
      return configured ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static bool isPlaceholderValue(String value) {
    final normalized = value.trim().toUpperCase();
    return normalized.isEmpty || normalized.startsWith(_placeholderPrefix);
  }
}
