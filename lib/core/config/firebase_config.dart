import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        if (kDebugMode) {
          debugPrint('Firebase initialized successfully');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to initialize Firebase: $e');
      }
      rethrow;
    }
  }

  static bool get isInitialized => Firebase.apps.isNotEmpty;
}

