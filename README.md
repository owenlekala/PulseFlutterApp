# Flutter App Template

A production-ready Flutter application template with Firebase integration, comprehensive theming, reusable widgets, and best practices for scalable app development.

## Features

### 🎨 Theme System
- **Light & Dark Mode**: Full support with Material 3 design
- **Theme Persistence**: Automatically saves user's theme preference
- **Customizable Colors**: Comprehensive color system with semantic naming
- **Typography**: Pre-configured text styles for consistent UI

### 🔥 Firebase Integration
- **Firebase Core**: Pre-configured and ready to use
- **Firebase Auth**: Authentication support included
- **Easy Configuration**: Simple setup with FlutterFire CLI

### 🗺️ Google Maps
- **Interactive Maps**: Google Maps integration with customizable markers
- **Location Services**: Built-in location tracking support
- **Custom Controls**: Easy-to-use map widget wrapper

### 📊 Charts & Data Visualization
- **Line Charts**: Interactive line charts using fl_chart
- **Bar Charts**: Customizable bar charts
- **Pie Charts**: Visual data representation with legends

### 🎯 Reusable Widgets
- **Input Widgets**: Text fields, dropdowns, date/time pickers, places picker
- **Buttons**: Primary, secondary, outlined, and text button variants
- **Cards**: Consistent card components
- **Dialogs**: Customizable dialog system
- **Loading Indicators**: Various loading states

### 🧭 Navigation
- **GoRouter**: Modern declarative routing
- **Type-safe Routes**: Route constants for better maintainability
- **Error Handling**: Built-in 404 error pages

### 🎨 Icons
- **Ming Cute Icons**: Beautiful icon library with line and filled variants
- **Centralized Icon Management**: Easy icon access through `AppIcons` class

### ⚙️ Configuration
- **Environment Variables**: Support for dev, staging, and production environments
- **API Configuration**: Centralized API endpoint management
- **App Configuration**: Version, build number, and app metadata

## Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart SDK
- Firebase account (for Firebase features)
- Google Maps API key (for maps functionality)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd app_template
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Environment Configuration

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and fill in your actual values:
   ```env
   APP_ENV=dev
   API_BASE_URL=https://api.example.com
   API_VERSION=v1
   APP_VERSION=1.0.0
   APP_BUILD_NUMBER=1
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
   ```

### 4. Firebase Setup

1. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. Configure Firebase:
   ```bash
   flutterfire configure
   ```

   This generates `lib/firebase_options.dart` with your Firebase configuration.

### 5. Google Maps Setup

1. Get a Google Maps API key from [Google Cloud Console](https://console.cloud.google.com/)
2. Add the API key to your `.env` file
3. For Android, add to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY"/>
   ```
4. For iOS, configure in `ios/Runner/Info.plist`

### 6. Run the App

```bash
flutter run
```

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
│   ├── routing/
│   │   └── app_router.dart      # Navigation configuration
│   ├── theme/                   # Theme system
│   │   ├── app_theme.dart       # Main theme configuration
│   │   ├── app_colors.dart      # Color definitions
│   │   └── app_text_styles.dart # Text style definitions
│   └── utils/
│       ├── env_loader.dart      # Environment variable loader
│       └── app_icons.dart        # Icon helper
├── features/                    # Feature modules
│   ├── home/                    # Home feature
│   ├── splash/                  # Splash screen
│   └── README.md                # Feature structure guide
└── shared/
    └── widgets/                 # Reusable widgets
        ├── inputs/               # Input widgets
        ├── buttons/              # Button widgets
        ├── cards/                # Card widgets
        ├── loading/              # Loading indicators
        ├── dialogs/              # Dialog widgets
        ├── charts/               # Chart widgets
        └── maps/                 # Map widgets
```

## Key Dependencies

- **firebase_core**: Firebase integration
- **firebase_auth**: Authentication
- **provider**: State management
- **go_router**: Navigation
- **shared_preferences**: Local storage
- **flutter_dotenv**: Environment variables
- **fl_chart**: Charts and graphs
- **google_maps_flutter**: Maps integration
- **ming_cute_icons**: Icon library

## Usage Examples

### Using Theme

```dart
// Toggle theme
Provider.of<ThemeProvider>(context, listen: false).toggleTheme();

// Access theme colors
final color = AppColors.getPrimary(Theme.of(context).brightness);
```

### Using Icons

```dart
Icon(AppIcons.home)
Icon(AppIcons.settingsFilled)
```

### Using Widgets

```dart
// Text Field
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
)

// Button
AppButton(
  text: 'Submit',
  type: AppButtonType.primary,
  onPressed: () {},
)

// Dialog
AppDialog(
  title: 'Confirm',
  message: 'Are you sure?',
  onConfirm: () {},
)
```

### Navigation

```dart
// Navigate using GoRouter
context.go(AppRoutes.home);

// Or use the router directly
AppRouter.router.go('/home');
```

## Development

### Running Tests

```bash
flutter test
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or contributions, please open an issue on the repository.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All the package maintainers for their excellent work
