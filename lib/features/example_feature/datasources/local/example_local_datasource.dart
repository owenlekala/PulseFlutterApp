import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../dtos/example_response_dto.dart';

/// Local Datasource for Example Feature
/// Handles local storage and caching
class ExampleLocalDatasource {
  static const String _examplesCacheKey = 'examples_cache';
  static const String _exampleCachePrefix = 'example_cache_';

  /// Cache a single example
  Future<void> cacheExample(ExampleResponseDto dto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      '$_exampleCachePrefix${dto.id}',
      jsonEncode(dto.toJson()),
    );
  }

  /// Get cached example by ID
  Future<ExampleResponseDto?> getCachedExample(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('$_exampleCachePrefix$id');
    if (cached != null) {
      try {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        return ExampleResponseDto.fromJson(json);
      } catch (e) {
        // If parsing fails, remove corrupted cache
        await prefs.remove('$_exampleCachePrefix$id');
        return null;
      }
    }
    return null;
  }

  /// Cache a list of examples
  Future<void> cacheExamples(List<ExampleResponseDto> dtos) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = dtos.map((dto) => dto.toJson()).toList();
    await prefs.setString(_examplesCacheKey, jsonEncode(jsonList));
  }

  /// Get cached examples list
  Future<List<ExampleResponseDto>> getCachedExamples() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_examplesCacheKey);
    if (cached != null) {
      try {
        final jsonList = jsonDecode(cached) as List;
        return jsonList
            .map((item) => ExampleResponseDto.fromJson(
                  item as Map<String, dynamic>,
                ))
            .toList();
      } catch (e) {
        // If parsing fails, remove corrupted cache
        await prefs.remove(_examplesCacheKey);
        return [];
      }
    }
    return [];
  }

  /// Clear all cached examples
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_examplesCacheKey);
    // Optionally clear individual example caches
    final keys = prefs.getKeys().where(
      (key) => key.startsWith(_exampleCachePrefix),
    );
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Clear cache for a specific example
  Future<void> clearExampleCache(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_exampleCachePrefix$id');
  }
}

