# DTO (Data Transfer Object) Guide

## What are DTOs?

DTOs (Data Transfer Objects) are objects that carry data between processes or layers. In our app, they represent the structure of data sent to and received from the API.

## Why Use DTOs?

1. **API Independence**: Domain models don't depend on API structure
2. **Type Safety**: Strong typing for API requests/responses
3. **Validation**: Can validate API data before converting to models
4. **Flexibility**: API can change without affecting domain models
5. **Serialization**: Easy JSON conversion

## DTO Structure

### Request DTOs

Request DTOs represent data sent to the API.

```dart
class LoginRequestDto {
  final String email;
  final String password;

  LoginRequestDto({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
```

**Key Points:**
- Use `toJson()` method for serialization
- Include all required fields
- Handle optional fields with null checks
- Match API field names exactly

### Response DTOs

Response DTOs represent data received from the API.

```dart
class UserResponseDto {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;

  UserResponseDto({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  factory UserResponseDto.fromJson(Map<String, dynamic> json) {
    return UserResponseDto(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
```

**Key Points:**
- Use `fromJson()` factory constructor for deserialization
- Use `toJson()` for caching or re-serialization
- Handle type conversions (String to DateTime, etc.)
- Handle nullable fields
- Match API field names exactly

## Best Practices

### 1. Naming Conventions

- Request DTOs: `[Entity]RequestDto` (e.g., `LoginRequestDto`)
- Response DTOs: `[Entity]ResponseDto` or `[Entity]Dto` (e.g., `UserResponseDto`, `ProductDto`)
- List DTOs: `[Entity]ListDto` or use `List<[Entity]Dto>` (e.g., `List<ProductDto>`)

### 2. Field Mapping

```dart
// API uses snake_case
'created_at' -> createdAt (camelCase in Dart)

// Handle different field names
factory UserDto.fromJson(Map<String, dynamic> json) {
  return UserDto(
    id: json['id'] as String,
    // Map API field to DTO field
    fullName: json['full_name'] as String,
    email: json['email'] as String,
  );
}
```

### 3. Type Safety

```dart
// Always use explicit types
final String id = json['id'] as String;
final int count = json['count'] as int;
final bool isActive = json['is_active'] as bool;

// Handle nullable fields
final String? description = json['description'] as String?;
```

### 4. Date/Time Handling

```dart
// Parse ISO 8601 strings
createdAt: DateTime.parse(json['created_at'] as String),

// Handle nullable dates
createdAt: json['created_at'] != null
    ? DateTime.parse(json['created_at'] as String)
    : null,

// Serialize dates
'created_at': createdAt.toIso8601String(),
```

### 5. Nested Objects

```dart
class AddressDto {
  final String street;
  final String city;

  AddressDto({required this.street, required this.city});

  factory AddressDto.fromJson(Map<String, dynamic> json) {
    return AddressDto(
      street: json['street'] as String,
      city: json['city'] as String,
    );
  }
}

class UserDto {
  final String id;
  final AddressDto? address;

  UserDto({required this.id, this.address});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      address: json['address'] != null
          ? AddressDto.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}
```

### 6. Lists and Arrays

```dart
// List of DTOs
final List<UserDto> users = (json['users'] as List)
    .map((item) => UserDto.fromJson(item as Map<String, dynamic>))
    .toList();

// Or in response wrapper
class UsersResponseDto {
  final List<UserDto> users;
  final int total;

  UsersResponseDto({required this.users, required this.total});

  factory UsersResponseDto.fromJson(Map<String, dynamic> json) {
    return UsersResponseDto(
      users: (json['users'] as List)
          .map((item) => UserDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );
  }
}
```

### 7. Error Handling

```dart
factory UserDto.fromJson(Map<String, dynamic> json) {
  try {
    return UserDto(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  } catch (e) {
    throw FormatException('Failed to parse UserDto: $e');
  }
}
```

## DTO to Model Conversion

DTOs should be converted to domain models in the Provider:

```dart
// In Provider
ExampleModel _dtoToModel(ExampleResponseDto dto) {
  return ExampleModel(
    id: dto.id,
    name: dto.name,
    createdAt: dto.createdAt,
  );
}
```

**Why not in DTO?**
- Keeps DTOs focused on API structure
- Allows models to have different structure
- Provides flexibility for business logic

## Example: Complete DTO

```dart
class ProductDto {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  ProductDto({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.tags,
    required this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: (json['tags'] as List).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'tags': tags,
      'created_at': createdAt.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }
}
```

## Testing DTOs

```dart
void main() {
  test('ProductDto fromJson', () {
    final json = {
      'id': '1',
      'name': 'Test Product',
      'description': 'Test Description',
      'price': 99.99,
      'stock': 10,
      'tags': ['tag1', 'tag2'],
      'created_at': '2024-01-01T00:00:00Z',
    };

    final dto = ProductDto.fromJson(json);
    expect(dto.id, '1');
    expect(dto.name, 'Test Product');
  });

  test('ProductDto toJson', () {
    final dto = ProductDto(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      stock: 10,
      tags: ['tag1'],
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    final json = dto.toJson();
    expect(json['id'], '1');
    expect(json['name'], 'Test Product');
  });
}
```

