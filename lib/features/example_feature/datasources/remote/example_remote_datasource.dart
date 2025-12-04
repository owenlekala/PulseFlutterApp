import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../core/config/api_config.dart';
import '../../../../../core/config/api_endpoints.dart';
import '../../dtos/example_request_dto.dart';
import '../../dtos/example_response_dto.dart';

/// Remote Datasource for Example Feature
/// Handles all API calls related to this feature
class ExampleRemoteDatasource {
  /// Get a single example by ID
  Future<ExampleResponseDto> getExample(String id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiEndpoints.items}/$id'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExampleResponseDto.fromJson(json);
      } else {
        throw Exception(
          'Failed to load example: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching example: $e');
    }
  }

  /// Get all examples
  Future<List<ExampleResponseDto>> getExamples() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiEndpoints.items),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final items = json['items'] as List;
        return items
            .map((item) => ExampleResponseDto.fromJson(
                  item as Map<String, dynamic>,
                ))
            .toList();
      } else {
        throw Exception(
          'Failed to load examples: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching examples: $e');
    }
  }

  /// Create a new example
  Future<ExampleResponseDto> createExample(ExampleRequestDto request) async {
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
        return ExampleResponseDto.fromJson(json);
      } else {
        throw Exception(
          'Failed to create example: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating example: $e');
    }
  }

  /// Update an existing example
  Future<ExampleResponseDto> updateExample(
    String id,
    ExampleRequestDto request,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiEndpoints.items}/$id'),
            headers: ApiConfig.defaultHeaders,
            body: jsonEncode(request.toJson()),
          )
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExampleResponseDto.fromJson(json);
      } else {
        throw Exception(
          'Failed to update example: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating example: $e');
    }
  }

  /// Delete an example
  Future<void> deleteExample(String id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiEndpoints.items}/$id'),
            headers: ApiConfig.defaultHeaders,
          )
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(
          'Failed to delete example: ${response.statusCode} - ${response.body}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting example: $e');
    }
  }
}

