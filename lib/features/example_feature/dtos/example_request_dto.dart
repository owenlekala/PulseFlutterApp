/// Example Request DTO
/// Represents the structure of data sent to the API
class ExampleRequestDto {
  final String field1;
  final int field2;
  final String? optionalField;

  ExampleRequestDto({
    required this.field1,
    required this.field2,
    this.optionalField,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'field1': field1,
      'field2': field2,
      if (optionalField != null) 'optional_field': optionalField,
    };
  }
}

