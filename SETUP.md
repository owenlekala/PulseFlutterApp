# Flutter App Template - Setup Guide

This is a production-ready Flutter app template with Firebase integration, environment configuration, comprehensive theming, and reusable widgets.

## Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account (for Firebase features)
- Google Maps API key (for maps functionality)

## Initial Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Environment Configuration

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and fill in your actual values:
   - `APP_ENV`: Set to `dev`, `staging`, or `production`
   - `API_BASE_URL`: Your API base URL
   - `API_VERSION`: API version (e.g., `v1`)
   - `APP_VERSION`: App version
   - `APP_BUILD_NUMBER`: Build number
   - `GOOGLE_MAPS_API_KEY`: Your Google Maps API key

### 3. Firebase Setup

1. Install FlutterFire CLI (if not already installed):
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Configure Firebase for your project:
   ```bash
   flutterfire configure
   ```

   This will:
   - Generate `lib/firebase_options.dart` with your Firebase configuration
   - Set up Firebase for all platforms (iOS, Android, Web, etc.)

3. Make sure Firebase is enabled in your Firebase Console:
   - Authentication (for Firebase Auth)
   - Any other services you need

### 4. Google Maps Setup

1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Add the API key to your `.env` file:
   ```
   GOOGLE_MAPS_API_KEY=your_api_key_here
   ```

3. For Android, add the API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY"/>
   ```

4. For iOS, add the API key to `ios/Runner/AppDelegate.swift` or configure in Info.plist

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── config/                  # Configuration files
│   │   ├── app_config.dart      # App-level configuration
│   │   ├── api_config.dart      # API configuration
│   │   ├── api_endpoints.dart   # API endpoints
│   │   ├── firebase_config.dart # Firebase initialization
│   │   └── environment.dart     # Environment enum
│   ├── constants/
│   │   └── app_constants.dart   # App-wide constants
│   ├── theme/                   # Theme system
│   │   ├── app_theme.dart      # Main theme configuration
│   │   ├── app_colors.dart     # Color definitions
│   │   └── app_text_styles.dart # Text style definitions
│   └── utils/
│       ├── env_loader.dart     # Environment variable loader
│       └── app_icons.dart      # Mingcute icon helper
└── shared/
    └── widgets/                 # Reusable widgets
        ├── inputs/              # Input widgets
        ├── buttons/             # Button widgets
        ├── cards/               # Card widgets
        ├── loading/             # Loading indicators
        ├── dialogs/             # Dialog widgets
        ├── charts/              # Chart widgets
        └── maps/                # Map widgets
```

## Features

### Theme System

The app includes a comprehensive theme system with:
- Light and dark mode support
- Material 3 design
- Customizable colors and text styles
- Theme persistence using SharedPreferences

Toggle theme using:
```dart
Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
```

### Shared Widgets

#### Inputs
- `AppTextField`: Custom text field with validation and password toggle
- `AppDropdown`: Custom dropdown with consistent styling

#### Buttons
- `AppButton`: Primary, secondary, outlined, and text button variants
- `AppIconButton`: Icon button with tooltip support

#### Cards
- `AppCard`: Reusable card component with elevation and padding

#### Loading
- `AppLoadingIndicator`: Circular and linear loading indicators

#### Dialogs
- `AppDialog`: Custom dialog with icon support
- `AppAlertDialog`: Alert dialog
- `AppConfirmDialog`: Confirmation dialog

#### Charts
- `AppLineChart`: Line chart widget
- `AppBarChart`: Bar chart widget
- `AppPieChart`: Pie chart widget

#### Maps
- `AppGoogleMap`: Google Maps widget with marker and polyline support

### Icons

The app uses Mingcute icons. Access icons through `AppIcons`:
```dart
Icon(AppIcons.home)
Icon(AppIcons.search)
```

## Usage Examples

### Using Environment Variables

```dart
import 'core/utils/env_loader.dart';

final apiKey = EnvLoader.get('API_KEY');
final isProduction = EnvLoader.getBool('IS_PRODUCTION');
```

### Using API Configuration

```dart
import 'core/config/api_config.dart';
import 'core/config/api_endpoints.dart';

final baseUrl = ApiConfig.baseUrl;
final loginEndpoint = ApiEndpoints.login;
```

### Using Shared Widgets

```dart
// Text Field
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  },
)

// Button
AppButton(
  text: 'Submit',
  type: AppButtonType.primary,
  onPressed: () {
    // Handle press
  },
)

// Dialog
AppAlertDialog.show(
  context: context,
  title: 'Success',
  message: 'Operation completed successfully',
);
```

## Running the App

```bash
# Development
flutter run

# Production build
flutter build apk --release  # Android
flutter build ios --release   # iOS
```

## Notes

- The `.env` file is gitignored and should not be committed
- Firebase options will be generated by `flutterfire configure`
- Make sure to configure platform-specific settings for Google Maps
- All widgets support dark mode automatically through the theme system

## Troubleshooting

### Firebase not initializing
- Make sure you've run `flutterfire configure`
- Check that `firebase_options.dart` exists and has valid configuration
- Verify Firebase is enabled in your Firebase Console

### Environment variables not loading
- Ensure `.env` file exists in the project root
- Check that `.env` is listed in `pubspec.yaml` assets
- Verify environment variable names match those in `.env.example`

### Google Maps not showing
- Verify API key is set in `.env`
- Check platform-specific configuration (AndroidManifest.xml, Info.plist)
- Ensure Google Maps API is enabled in Google Cloud Console

