import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Setup global error handling for the app
class ErrorHandlerSetup {
  static void setup() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      
      // In production, you might want to log to a crash reporting service
      if (kReleaseMode) {
        // Example: Firebase Crashlytics
        // FirebaseCrashlytics.instance.recordFlutterError(details);
      }
    };

    // Handle errors outside of Flutter framework (async errors)
    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Platform error: $error');
        debugPrint('Stack: $stack');
      }

      // In production, log to crash reporting service
      if (kReleaseMode) {
        // Example: Firebase Crashlytics
        // FirebaseCrashlytics.instance.recordError(error, stack);
      }

      return true; // Return true to prevent app from crashing
    };

    // Custom error widget builder
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (kDebugMode) {
        // In debug mode, show the default error widget
        return ErrorWidget(details.exception);
      } else {
        // In release mode, show a user-friendly error screen
        return Material(
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'We apologize for the inconvenience. Please restart the app.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    };
  }
}

