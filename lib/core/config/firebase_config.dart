import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class FirebaseConfig {
  static const Set<String> _placeholderValues = {
    'your-web-api-key',
    'your-web-app-id',
    'your-android-api-key',
    'your-android-app-id',
    'your-ios-api-key',
    'your-ios-app-id',
    'your-macos-api-key',
    'your-macos-app-id',
    'your-messaging-sender-id',
    'your-project-id',
    'your-project-id.appspot.com',
    'your-project-id.firebaseapp.com',
  };

  static Future<bool> initialize() async {
    final options = DefaultFirebaseOptions.currentPlatform;

    if (!_hasUsableOptions(options)) {
      if (kDebugMode) {
        debugPrint(
          'Skipping Firebase initialization: placeholder FlutterFire configuration detected.',
        );
      }
      return false;
    }

    final existingApp = _tryGetDefaultApp();
    if (existingApp != null) {
      if (kDebugMode) {
        debugPrint(
          'Firebase already initialized for app "${existingApp.name}".',
        );
      }
      return true;
    }

    try {
      await Firebase.initializeApp(options: options);
      if (kDebugMode) {
        debugPrint('Firebase initialized successfully');
      }
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app' && _tryGetDefaultApp() != null) {
        if (kDebugMode) {
          debugPrint(
            'Firebase duplicate-app ignored because default app already exists.',
          );
        }
        return true;
      }

      if (kDebugMode) {
        debugPrint('Failed to initialize Firebase: ${e.code} ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize Firebase: $e');
      }
      rethrow;
    }
  }

  static bool get isInitialized => Firebase.apps.isNotEmpty;

  static FirebaseApp? _tryGetDefaultApp() {
    try {
      return Firebase.app();
    } catch (_) {
      return null;
    }
  }

  static bool _hasUsableOptions(FirebaseOptions options) {
    final values = <String>[
      options.apiKey,
      options.appId,
      options.messagingSenderId,
      options.projectId,
      if (options.authDomain != null) options.authDomain!,
      if (options.storageBucket != null) options.storageBucket!,
      if (options.iosBundleId != null) options.iosBundleId!,
    ];

    return values.every(
      (value) => value.isNotEmpty && !_placeholderValues.contains(value),
    );
  }
}
