# Datasource Guide

## What are Datasources?

Datasources are responsible for fetching and storing data. They abstract the data layer from the business logic.

## Types of Datasources

### 1. Remote Datasources

Handle API calls and network communication.

**Location**: `features/[feature]/datasources/remote/`

**Responsibilities:**
- Make HTTP requests to API
- Handle network errors
- Parse API responses to DTOs
- Return DTOs (not domain models)

### 2. Local Datasources

Handle local storage and caching.

**Location**: `features/[feature]/datasources/local/`

**Responsibilities:**
- Cache API responses
- Store user preferences
- Handle offline data
- Use SharedPreferences, SQLite, Hive, etc.

## Remote Datasource Pattern

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/config/api_config.dart';
import '../../../../core/config/api_endpoints.dart';
import '../../dtos/example_dto.dart';

class ExampleRemoteDatasource {
  /// GET request example
  Future<ExampleDto> getExample(String id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiEndpoints.items}/$id'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExampleDto.fromJson(json);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// POST request example
  Future<ExampleDto> createExample(ExampleRequestDto request) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiEndpoints.items),
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExampleDto.fromJson(json);
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
```

## Local Datasource Pattern

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../dtos/example_dto.dart';

class ExampleLocalDatasource {
  static const String _cacheKey = 'example_cache';

  /// Cache data
  Future<void> cacheExample(ExampleDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(dto.toJson()));
  }

  /// Get cached data
  Future<ExampleDto?> getCachedExample() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      try {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        return ExampleDto.fromJson(json);
      } catch (e) {
        // Remove corrupted cache
        await prefs.remove(_cacheKey);
        return null;
      }
    }
    return null;
  }

  /// Clear cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}
```

## Best Practices

### 1. Error Handling

```dart
Future<ExampleDto> getExample(String id) async {
  try {
    final response = await http.get(...);
    
    if (response.statusCode == 200) {
      return ExampleDto.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw NotFoundException('Example not found');
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Unauthorized');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  } on http.ClientException catch (e) {
    throw NetworkException('Network error: ${e.message}');
  } on FormatException catch (e) {
    throw ParseException('Invalid response format: $e');
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}
```

### 2. Timeout Handling

```dart
// Use ApiConfig timeout
.timeout(ApiConfig.connectTimeout)

// Or custom timeout
.timeout(const Duration(seconds: 10))
```

### 3. Request Headers

```dart
// Use ApiConfig default headers
headers: ApiConfig.defaultHeaders

// Or add custom headers
headers: {
  ...ApiConfig.defaultHeaders,
  'Authorization': 'Bearer $token',
  'Custom-Header': 'value',
}
```

### 4. Query Parameters

```dart
final uri = Uri.parse(ApiEndpoints.items).replace(
  queryParameters: {
    'page': '1',
    'limit': '20',
    'sort': 'name',
  },
);
final response = await http.get(uri, headers: ApiConfig.defaultHeaders);
```

### 5. Pagination

```dart
Future<PaginatedResponse<ExampleDto>> getExamples({
  int page = 1,
  int limit = 20,
}) async {
  final uri = Uri.parse(ApiEndpoints.items).replace(
    queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    },
  );
  
  final response = await http.get(uri, headers: ApiConfig.defaultHeaders);
  
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return PaginatedResponse<ExampleDto>.fromJson(
      json,
      (item) => ExampleDto.fromJson(item as Map<String, dynamic>),
    );
  }
  throw Exception('Failed to load examples');
}
```

### 6. File Upload

```dart
Future<ExampleDto> uploadFile(String filePath) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('${ApiEndpoints.items}/upload'),
  );
  
  request.headers.addAll(ApiConfig.defaultHeaders);
  request.files.add(
    await http.MultipartFile.fromPath('file', filePath),
  );
  
  final streamedResponse = await request.send();
  final response = await http.Response.fromStream(streamedResponse);
  
  if (response.statusCode == 200) {
    return ExampleDto.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
  throw Exception('Upload failed');
}
```

### 7. Caching Strategy

```dart
class ExampleLocalDatasource {
  // Cache with expiration
  static const String _cacheKey = 'example_cache';
  static const String _cacheTimestampKey = 'example_cache_timestamp';
  static const Duration _cacheExpiration = Duration(hours: 1);

  Future<void> cacheExample(ExampleDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(dto.toJson()));
    await prefs.setInt(
      _cacheTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<ExampleDto?> getCachedExample() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_cacheTimestampKey);
    
    if (timestamp == null) return null;
    
    final cacheAge = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
    
    if (cacheAge > _cacheExpiration) {
      await clearCache();
      return null;
    }
    
    final cached = prefs.getString(_cacheKey);
    if (cached != null) {
      try {
        return ExampleDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
      } catch (e) {
        await clearCache();
        return null;
      }
    }
    return null;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimestampKey);
  }
}
```

## Testing Datasources

```dart
// Mock HTTP client for testing
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ExampleRemoteDatasource datasource;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    datasource = ExampleRemoteDatasource();
  });

  test('getExample returns ExampleDto on success', () async {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(
              jsonEncode({'id': '1', 'name': 'Test'}),
              200,
            ));

    final result = await datasource.getExample('1');
    expect(result.id, '1');
    expect(result.name, 'Test');
  });
}
```

## Common Patterns

### 1. Retry Logic

```dart
Future<ExampleDto> getExampleWithRetry(String id, {int retries = 3}) async {
  for (int i = 0; i < retries; i++) {
    try {
      return await getExample(id);
    } catch (e) {
      if (i == retries - 1) rethrow;
      await Future.delayed(Duration(seconds: i + 1));
    }
  }
  throw Exception('Max retries exceeded');
}
```

### 2. Batch Requests

```dart
Future<List<ExampleDto>> getExamplesBatch(List<String> ids) async {
  final futures = ids.map((id) => getExample(id));
  return await Future.wait(futures);
}
```

### 3. Conditional Caching

```dart
Future<ExampleDto> getExampleWithCache(String id) async {
  // Try cache first
  final cached = await _localDatasource.getCachedExample(id);
  if (cached != null) {
    return cached;
  }
  
  // Fetch from API
  final dto = await _remoteDatasource.getExample(id);
  
  // Cache result
  await _localDatasource.cacheExample(dto);
  
  return dto;
}
```

