# Snackbar Widgets

Reusable snackbar widgets that follow the app theme and provide consistent messaging across the application.

## Usage

### Quick Methods

```dart
// Success snackbar
AppSnackBar.showSuccess(context, 'Operation completed successfully!');

// Error snackbar
AppSnackBar.showError(context, 'Something went wrong. Please try again.');

// Warning snackbar
AppSnackBar.showWarning(context, 'Please check your input before proceeding.');

// Info snackbar
AppSnackBar.showInfo(context, 'New features are available. Check them out!');
```

### With Action Button

```dart
AppSnackBar.showSuccess(
  context,
  'Item deleted successfully',
  actionLabel: 'Undo',
  onAction: () {
    // Handle undo action
    AppSnackBar.showInfo(context, 'Action undone');
  },
);
```

### Using SnackBarHelper

```dart
// Alternative helper class
SnackBarHelper.success(context, 'Success message');
SnackBarHelper.error(context, 'Error message');
SnackBarHelper.warning(context, 'Warning message');
SnackBarHelper.info(context, 'Info message');
```

### Custom Duration

```dart
AppSnackBar.showError(
  context,
  'This error message will show for 5 seconds',
  duration: const Duration(seconds: 5),
);
```

## Features

- **Theme-aware**: Automatically adapts to light/dark mode
- **Consistent styling**: Uses app colors and icons
- **Action support**: Optional action buttons
- **Floating behavior**: Appears above content
- **Customizable duration**: Control how long snackbars are displayed
- **Icon support**: Each type has a default icon (can be customized)

## Types

- **Success**: Green background, check circle icon
- **Error**: Red background, alert icon
- **Warning**: Orange/yellow background, warning icon
- **Info**: Blue background, information icon

## Best Practices

1. **Use appropriate types**: Match the snackbar type to the message
2. **Keep messages concise**: Short, clear messages work best
3. **Use actions sparingly**: Only add action buttons when necessary
4. **Consider duration**: Error messages might need longer duration
5. **Don't stack**: Avoid showing multiple snackbars at once

## Examples

### Success Message
```dart
AppSnackBar.showSuccess(
  context,
  'Profile updated successfully',
);
```

### Error with Retry
```dart
AppSnackBar.showError(
  context,
  'Failed to load data',
  actionLabel: 'Retry',
  onAction: () {
    // Retry logic
    loadData();
  },
);
```

### Warning
```dart
AppSnackBar.showWarning(
  context,
  'Your session will expire in 5 minutes',
);
```

### Info
```dart
AppSnackBar.showInfo(
  context,
  'New update available',
  actionLabel: 'Update',
  onAction: () {
    // Navigate to update screen
  },
);
```

