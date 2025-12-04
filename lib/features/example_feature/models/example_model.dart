import '../dtos/example_response_dto.dart';


/// Example Domain Model
/// Represents a business entity, independent of API structure
class ExampleModel {
  final String id;
  final String name;
  final DateTime createdAt;

  ExampleModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  /// Create from DTO
  /// This conversion should typically happen in the provider
  factory ExampleModel.fromDto(ExampleResponseDto dto) {
    return ExampleModel(
      id: dto.id,
      name: dto.name,
      createdAt: dto.createdAt,
    );
  }
}

