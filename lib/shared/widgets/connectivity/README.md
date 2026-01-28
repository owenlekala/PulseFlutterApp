# Connectivity Widgets

This directory contains widgets for handling internet connectivity states in the app.

## Components

### NoInternetScreen

A full-screen widget that displays when there's no internet connection.

**Usage:**

```dart
// Simple usage
NoInternetScreen(
  onRetry: () {
    // Handle retry action
    print('Retrying...');
  },
)

// Customized usage
NoInternetScreen(
  title: 'Connection Lost',
  message: 'Please check your network settings.',
  retryButtonText: 'Try Again',
  onRetry: () {
    // Your retry logic
  },
  showRetryButton: true,
)
```

### ConnectivityWrapper

A wrapper widget that automatically shows the NoInternetScreen when the device is offline.

**Usage:**

```dart
// Wrap your entire app or specific screens
ConnectivityWrapper(
  child: YourMainWidget(),
  showOfflineScreen: true, // Set to false to disable auto-show
)

// With custom offline widget
ConnectivityWrapper(
  child: YourMainWidget(),
  offlineWidget: CustomOfflineWidget(),
)
```

## ConnectivityHelper

A utility class for checking internet connectivity status.

**Usage:**

```dart
// Check connectivity once
final isConnected = await ConnectivityHelper.checkConnectivity();

// Listen to connectivity changes
ConnectivityHelper.listen((result) {
  print('Connectivity changed: $result');
});

// Access current status
final isConnected = ConnectivityHelper.isConnected.value;
final connectivityResult = ConnectivityHelper.connectivityResult.value;
```

## Example Integration

### Option 1: Wrap entire app (Recommended)

```dart
// In main.dart or app root
ConnectivityWrapper(
  child: MaterialApp.router(
    // ... your app config
  ),
)
```

### Option 2: Show screen manually

```dart
// In your screen/widget
ValueListenableBuilder<bool>(
  valueListenable: ConnectivityHelper.isConnected,
  builder: (context, isConnected, child) {
    if (!isConnected) {
      return NoInternetScreen(
        onRetry: () {
          // Refresh your data
        },
      );
    }
    return YourContentWidget();
  },
)
```

### Option 3: Show as overlay/dialog

```dart
// Check connectivity before API calls
final isConnected = await ConnectivityHelper.checkConnectivity();
if (!isConnected) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NoInternetScreen(),
    ),
  );
  return;
}
// Proceed with API call
```

## Notes

- The `connectivity_plus` package is required (already added to pubspec.yaml)
- Android requires `ACCESS_NETWORK_STATE` permission (already added to AndroidManifest.xml)
- iOS doesn't require any special permissions for connectivity checks
- The connectivity check only verifies if the device has a network connection, not if it can reach the internet
