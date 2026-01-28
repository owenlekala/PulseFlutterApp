import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../buttons/app_button.dart';

/// A screen widget that displays when there's no internet connection
class NoInternetScreen extends StatefulWidget {
  final String? title;
  final String? message;
  final String? retryButtonText;
  final VoidCallback? onRetry;
  final Widget? customIcon;
  final bool showRetryButton;

  const NoInternetScreen({
    super.key,
    this.title,
    this.message,
    this.retryButtonText,
    this.onRetry,
    this.customIcon,
    this.showRetryButton = true,
  });

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    // Check connectivity
    final isConnected = await ConnectivityHelper.checkConnectivity();

    if (mounted) {
      setState(() {
        _isRetrying = false;
      });

      if (isConnected) {
        // If connected, call the onRetry callback
        widget.onRetry?.call();
      } else {
        // Still no connection, could show a message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Still no internet connection. Please check your network settings.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    return Scaffold(
      backgroundColor: AppColors.getBackground(brightness),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                if (widget.customIcon != null)
                  widget.customIcon!
                else
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 120,
                    color: AppColors.getTextSecondary(brightness),
                  ),
                const SizedBox(height: 32),

                // Title
                Text(
                  widget.title ?? 'No Internet Connection',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(brightness),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Message
                Text(
                  widget.message ??
                      'Please check your internet connection and try again.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.getTextSecondary(brightness),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Retry Button
                if (widget.showRetryButton)
                  AppButton(
                    text: widget.retryButtonText ?? 'Retry',
                    type: AppButtonType.primary,
                    onPressed: _isRetrying ? null : _handleRetry,
                    isLoading: _isRetrying,
                    icon: _isRetrying
                        ? null
                        : const Icon(Icons.refresh_rounded),
                    isFullWidth: false,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A wrapper widget that automatically shows NoInternetScreen when offline
class ConnectivityWrapper extends StatefulWidget {
  final Widget child;
  final Widget? offlineWidget;
  final bool showOfflineScreen;

  const ConnectivityWrapper({
    super.key,
    required this.child,
    this.offlineWidget,
    this.showOfflineScreen = true,
  });

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  StreamSubscription? _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _subscription = ConnectivityHelper.listen((result) {
      final hasConnection =
          result.isNotEmpty && !result.contains(ConnectivityResult.none);
      if (mounted) {
        setState(() {
          _isConnected = hasConnection;
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showOfflineScreen || _isConnected) {
      return widget.child;
    }

    return widget.offlineWidget ??
        NoInternetScreen(
          onRetry: () {
            _checkConnectivity();
          },
        );
  }
}
