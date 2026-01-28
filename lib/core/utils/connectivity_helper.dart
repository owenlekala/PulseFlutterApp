import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Helper class for checking internet connectivity
class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;
  static final ValueNotifier<bool> _isConnected = ValueNotifier<bool>(true);
  static final ValueNotifier<ConnectivityResult> _connectivityResult =
      ValueNotifier<ConnectivityResult>(ConnectivityResult.none);

  /// Get the current connectivity status notifier
  static ValueNotifier<bool> get isConnected => _isConnected;

  /// Get the current connectivity result notifier
  static ValueNotifier<ConnectivityResult> get connectivityResult =>
      _connectivityResult;

  /// Check if device has internet connection
  /// Returns true if connected, false otherwise
  static Future<bool> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final hasConnection = result.isNotEmpty &&
          !result.contains(ConnectivityResult.none);
      
      _isConnected.value = hasConnection;
      if (result.isNotEmpty) {
        _connectivityResult.value = result.first;
      }
      
      return hasConnection;
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }

  /// Start listening to connectivity changes
  /// Returns a stream of connectivity results
  static StreamSubscription<List<ConnectivityResult>> listen(
    void Function(List<ConnectivityResult>) onConnectivityChanged,
  ) {
    _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> result) {
        final hasConnection =
            result.isNotEmpty && !result.contains(ConnectivityResult.none);
        _isConnected.value = hasConnection;
        if (result.isNotEmpty) {
          _connectivityResult.value = result.first;
        }
        onConnectivityChanged(result);
      },
    );
    return _subscription!;
  }

  /// Stop listening to connectivity changes
  static void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Dispose resources
  static void dispose() {
    stopListening();
    _isConnected.dispose();
    _connectivityResult.dispose();
  }
}
