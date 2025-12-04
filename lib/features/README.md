# Features Folder Structure

This folder contains all feature modules of the application. Each feature should be self-contained with its own screens, widgets, models, datasources, providers, and business logic.

## Recommended Structure

```
features/
├── feature_name/
│   ├── screens/          # Feature screens (UI)
│   ├── widgets/         # Feature-specific widgets
│   ├── models/          # Domain models/entities
│   ├── dtos/            # Data Transfer Objects (API response/request types)
│   ├── datasources/     # Data sources (API, local storage, etc.)
│   │   ├── remote/      # Remote data sources (API calls)
│   │   └── local/       # Local data sources (SharedPreferences, SQLite, etc.)
│   ├── providers/        # State management (Provider, Riverpod, etc.)
│   ├── services/         # Business logic/services
│   └── README.md         # Feature documentation
```

## Complete Example Feature Structure

```
features/
├── auth/
│   ├── screens/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── widgets/
│   │   └── auth_form.dart
│   ├── models/
│   │   └── user_model.dart
│   ├── dtos/
│   │   ├── login_request_dto.dart
│   │   ├── login_response_dto.dart
│   │   └── user_dto.dart
│   ├── datasources/
│   │   ├── remote/
│   │   │   └── auth_remote_datasource.dart
│   │   └── local/
│   │       └── auth_local_datasource.dart
│   ├── providers/
│   │   └── auth_provider.dart
│   └── services/
│       └── auth_service.dart
├── products/
│   ├── screens/
│   │   ├── products_list_screen.dart
│   │   └── product_detail_screen.dart
│   ├── widgets/
│   │   └── product_card.dart
│   ├── models/
│   │   └── product_model.dart
│   ├── dtos/
│   │   ├── product_dto.dart
│   │   └── products_response_dto.dart
│   ├── datasources/
│   │   ├── remote/
│   │   │   └── products_remote_datasource.dart
│   │   └── local/
│   │       └── products_local_datasource.dart
│   └── providers/
│       └── products_provider.dart
└── profile/
    ├── screens/
    │   └── profile_screen.dart
    └── widgets/
        └── profile_header.dart
```

## Component Descriptions

### Screens (`screens/`)
- UI screens/pages for the feature
- Should be minimal and delegate logic to providers/services
- Use shared widgets from `lib/shared/widgets` when possible

### Widgets (`widgets/`)
- Feature-specific reusable widgets
- Should not contain business logic
- Use theme from `lib/core/theme`

### Models (`models/`)
- Domain models/entities
- Pure Dart classes representing business objects
- Should not depend on API structure
- Example: `User`, `Product`, `Order`

### DTOs (`dtos/`)
- Data Transfer Objects for API communication
- Represent API request/response structures
- Should include `fromJson` and `toJson` methods
- Can be converted to/from domain models
- Example: `UserDto`, `LoginRequestDto`, `ProductResponseDto`

### Datasources (`datasources/`)

#### Remote Datasources (`datasources/remote/`)
- Handle API calls
- Use `http` package or similar
- Return DTOs, not domain models
- Handle errors and network issues
- Example: `AuthRemoteDatasource`, `ProductsRemoteDatasource`

#### Local Datasources (`datasources/local/`)
- Handle local storage (SharedPreferences, SQLite, Hive, etc.)
- Cache data for offline access
- Store user preferences
- Example: `AuthLocalDatasource`, `ProductsLocalDatasource`

### Providers (`providers/`)
- State management for the feature
- Combine data from datasources
- Convert DTOs to domain models
- Handle business logic
- Notify UI of state changes
- Example: `AuthProvider`, `ProductsProvider`

### Services (`services/`)
- Business logic that doesn't fit in providers
- Can be used across multiple features
- Example: `AuthService`, `ValidationService`

## Data Flow Pattern

```
UI (Screen) 
  ↓
Provider (State Management)
  ↓
Service (Business Logic - optional)
  ↓
Datasource (Remote/Local)
  ↓
API / Local Storage
  ↓
DTO (Data Transfer Object)
  ↓
Model (Domain Model)
  ↓
Back to Provider → UI
```

## Best Practices

1. **Separation of Concerns**: Keep UI, business logic, and data access separate
2. **DTO to Model Conversion**: Always convert DTOs to domain models in providers
3. **Error Handling**: Handle errors at datasource level and propagate to providers
4. **Caching**: Use local datasources for caching API responses
5. **Reusability**: Use shared widgets and utilities from `lib/shared`
6. **Testing**: Write unit tests for providers, services, and datasources
7. **Documentation**: Document complex features with README.md
8. **Type Safety**: Use strong typing with DTOs and models
9. **API Configuration**: Use `lib/core/config/api_config.dart` and `api_endpoints.dart` for API URLs

## Example Implementation

See the example feature templates in this folder for complete implementation patterns.
