# Example Feature - Implementation Guide

This is a template feature showing the complete structure with API integration.

## Structure

```
example_feature/
├── screens/
│   └── example_screen.dart
├── widgets/
│   └── example_widget.dart
├── models/
│   └── example_model.dart
├── dtos/
│   ├── example_request_dto.dart
│   └── example_response_dto.dart
├── datasources/
│   ├── remote/
│   │   └── example_remote_datasource.dart
│   └── local/
│       └── example_local_datasource.dart
└── providers/
    └── example_provider.dart
```

## Implementation Steps

### 1. Create DTOs (Data Transfer Objects)

DTOs represent the structure of API requests and responses.

**example_request_dto.dart**
```dart
class ExampleRequestDto {
  final String field1;
  final int field2;

  ExampleRequestDto({
    required this.field1,
    required this.field2,
  });

  Map<String, dynamic> toJson() {
    return {
      'field1': field1,
      'field2': field2,
    };
  }
}
```

**example_response_dto.dart**
```dart
class ExampleResponseDto {
  final String id;
  final String name;
  final DateTime createdAt;

  ExampleResponseDto({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory ExampleResponseDto.fromJson(Map<String, dynamic> json) {
    return ExampleResponseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

### 2. Create Domain Models

Models represent business entities, independent of API structure.

**example_model.dart**
```dart
class ExampleModel {
  final String id;
  final String name;
  final DateTime createdAt;

  ExampleModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}
```

### 3. Create Remote Datasource

Handles API calls and returns DTOs.

**example_remote_datasource.dart**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/config/api_config.dart';
import '../../../../core/config/api_endpoints.dart';
import '../dtos/example_request_dto.dart';
import '../dtos/example_response_dto.dart';

class ExampleRemoteDatasource {
  Future<ExampleResponseDto> getExample(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiEndpoints.items}/$id'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExampleResponseDto.fromJson(json);
      } else {
        throw Exception('Failed to load example: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching example: $e');
    }
  }

  Future<ExampleResponseDto> createExample(ExampleRequestDto request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.items),
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode(request.toJson()),
      ).timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExampleResponseDto.fromJson(json);
      } else {
        throw Exception('Failed to create example: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating example: $e');
    }
  }
}
```

### 4. Create Local Datasource

Handles local storage/caching.

**example_local_datasource.dart**
```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../dtos/example_response_dto.dart';

class ExampleLocalDatasource {
  static const String _cacheKey = 'example_cache';

  Future<void> cacheExample(ExampleResponseDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(dto.toJson()));
  }

  Future<ExampleResponseDto?> getCachedExample() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      final json = jsonDecode(cached) as Map<String, dynamic>;
      return ExampleResponseDto.fromJson(json);
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
```

### 5. Create Provider

Combines datasources, converts DTOs to models, manages state.

**example_provider.dart**
```dart
import 'package:flutter/foundation.dart';
import '../models/example_model.dart';
import '../dtos/example_response_dto.dart';
import '../datasources/remote/example_remote_datasource.dart';
import '../datasources/local/example_local_datasource.dart';

class ExampleProvider extends ChangeNotifier {
  final ExampleRemoteDatasource _remoteDatasource;
  final ExampleLocalDatasource _localDatasource;

  ExampleProvider({
    required ExampleRemoteDatasource remoteDatasource,
    required ExampleLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  ExampleModel? _example;
  bool _isLoading = false;
  String? _error;

  ExampleModel? get example => _example;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Convert DTO to Model
  ExampleModel _dtoToModel(ExampleResponseDto dto) {
    return ExampleModel(
      id: dto.id,
      name: dto.name,
      createdAt: dto.createdAt,
    );
  }

  Future<void> loadExample(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from cache first
      final cached = await _localDatasource.getCachedExample();
      if (cached != null && cached.id == id) {
        _example = _dtoToModel(cached);
        notifyListeners();
      }

      // Fetch from API
      final dto = await _remoteDatasource.getExample(id);
      _example = _dtoToModel(dto);
      
      // Cache the result
      await _localDatasource.cacheExample(dto);
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      // If API fails and no cache, show error
      if (_example == null) {
        _error = 'Failed to load example. Please check your connection.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

### 6. Create Screen

UI that uses the provider.

**example_screen.dart**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/example_provider.dart';
import '../../shared/widgets/loading/app_loading_indicator.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExampleProvider>().loadExample('example-id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Consumer<ExampleProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.example == null) {
            return const Center(
              child: AppLoadingIndicator(
                message: 'Loading...',
              ),
            );
          }

          if (provider.error != null && provider.example == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadExample('example-id'),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final example = provider.example;
          if (example == null) {
            return const Center(child: Text('No data'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadExample('example-id'),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  example.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${example.id}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Created: ${example.createdAt}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

## Key Points

1. **DTOs**: Represent API structure, include `fromJson`/`toJson`
2. **Models**: Represent business logic, independent of API
3. **Remote Datasource**: Makes API calls, returns DTOs
4. **Local Datasource**: Handles caching/storage
5. **Provider**: Converts DTOs to Models, manages state
6. **Screen**: Consumes provider, displays UI

## Testing

- Test DTOs: JSON serialization/deserialization
- Test Datasources: Mock HTTP responses, test error handling
- Test Providers: Test state changes, DTO to Model conversion
- Test Screens: Widget tests with mocked providers

