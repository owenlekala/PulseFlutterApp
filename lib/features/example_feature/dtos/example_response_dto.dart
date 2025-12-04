/// Example Response DTO
/// Represents the structure of data received from the API
class ExampleResponseDto {
  final String id;
  final String name;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  ExampleResponseDto({
    required this.id,
    required this.name,
    required this.createdAt,
    this.metadata,
  });

  /// Create from JSON API response
  factory ExampleResponseDto.fromJson(Map<String, dynamic> json) {
    return ExampleResponseDto(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON (useful for caching)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Convert to domain model
  /// This method should be in the provider, but can be here for convenience
  // ExampleModel toModel() {
  //   return ExampleModel(
  //     id: id,
  //     name: name,
  //     createdAt: createdAt,
  //   );
  // }
}

