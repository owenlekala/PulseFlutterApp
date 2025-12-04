# Error Handling

Comprehensive error handling system for the application including error boundaries, global error handlers, and error display utilities.

## Components

### 1. ErrorBoundary Widget

Wraps the app to catch errors in the widget tree and display a user-friendly error screen.

**Location**: `lib/core/error/error_boundary.dart`

**Usage**:
```dart
ErrorBoundary(
  child: YourApp(),
)
```

The ErrorBoundary is already set up in `main.dart` wrapping the entire app.

### 2. ErrorHandlerSetup

Sets up global error handling for Flutter framework errors and platform errors.

**Location**: `lib/core/error/error_handler_setup.dart`

**Features**:
- Catches Flutter framework errors
- Handles async errors outside Flutter framework
- Custom error widget builder
- Integration ready for crash reporting (Firebase Crashlytics, etc.)

### 3. ErrorHandler Utility

Provides convenient methods for displaying errors throughout the app.

**Location**: `lib/core/error/error_boundary.dart`

**Methods**:

#### Show Error Dialog
```dart
ErrorHandler.handleError(
  context,
  error,
  title: 'Error Title',
  message: 'Error message',
  onRetry: () {
    // Retry logic
  },
);
```

#### Show Error Snackbar
```dart
ErrorHandler.showErrorSnackBar(
  context,
  'Error message',
  duration: Duration(seconds: 3),
);
```

#### Show Success Snackbar
```dart
ErrorHandler.showSuccessSnackBar(
  context,
  'Success message',
);
```

### 4. ErrorScreen Widget

Custom error screen displayed when errors occur.

**Features**:
- User-friendly error message
- Retry button
- Go Home button
- Stack trace in debug mode
- Theme-aware styling

## Usage Examples

### In Providers

```dart
class ExampleProvider extends ChangeNotifier {
  Future<void> loadData() async {
    try {
      // API call
      final data = await _datasource.getData();
      // Process data
    } catch (e, stackTrace) {
      // Log error
      debugPrint('Error loading data: $e');
      
      // Show error to user
      if (context != null) {
        ErrorHandler.showErrorSnackBar(
          context!,
          'Failed to load data. Please try again.',
        );
      }
    }
  }
}
```

### In Screens

```dart
class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen(
              error: snapshot.error!,
              onRetry: () {
                // Retry loading
              },
            );
          }
          // Normal UI
        },
      ),
    );
  }
}
```

### In Datasources

```dart
class ExampleRemoteDatasource {
  Future<ExampleDto> getExample(String id) async {
    try {
      final response = await http.get(...);
      if (response.statusCode == 200) {
        return ExampleDto.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw NetworkException('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
```

## Error Types

### Custom Exception Classes

You can create custom exception classes for better error handling:

```dart
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
  
  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
  
  @override
  String toString() => message;
}
```

## Best Practices

1. **Catch specific errors**: Use specific exception types when possible
2. **Provide user-friendly messages**: Don't expose technical details to users
3. **Log errors**: Always log errors for debugging
4. **Offer recovery options**: Provide retry buttons or alternative actions
5. **Handle errors at appropriate levels**: 
   - Datasources: Throw exceptions
   - Providers: Catch and convert to user-friendly messages
   - Screens: Display errors to users

## Integration with Crash Reporting

To integrate with Firebase Crashlytics or other crash reporting services:

```dart
// In error_handler_setup.dart
if (kReleaseMode) {
  FirebaseCrashlytics.instance.recordFlutterError(details);
  FirebaseCrashlytics.instance.recordError(error, stack);
}
```

## Testing Error Handling

```dart
testWidgets('ErrorBoundary displays error screen', (tester) async {
  await tester.pumpWidget(
    ErrorBoundary(
      child: Builder(
        builder: (context) {
          throw Exception('Test error');
        },
      ),
    ),
  );
  
  expect(find.text('Something went wrong'), findsOneWidget);
});
```

