import 'package:flutter/foundation.dart';
import '../models/example_model.dart';
import '../dtos/example_request_dto.dart';
import '../dtos/example_response_dto.dart';
import '../datasources/remote/example_remote_datasource.dart';
import '../datasources/local/example_local_datasource.dart';

/// Provider for Example Feature
/// Manages state and coordinates between datasources
class ExampleProvider extends ChangeNotifier {
  final ExampleRemoteDatasource _remoteDatasource;
  final ExampleLocalDatasource _localDatasource;

  ExampleProvider({
    required ExampleRemoteDatasource remoteDatasource,
    required ExampleLocalDatasource localDatasource,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource;

  // State
  ExampleModel? _example;
  List<ExampleModel> _examples = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  ExampleModel? get example => _example;
  List<ExampleModel> get examples => _examples;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Convert DTO to Domain Model
  ExampleModel _dtoToModel(ExampleResponseDto dto) {
    return ExampleModel(
      id: dto.id,
      name: dto.name,
      createdAt: dto.createdAt,
    );
  }

  /// Convert list of DTOs to Models
  List<ExampleModel> _dtosToModels(List<ExampleResponseDto> dtos) {
    return dtos.map((dto) => _dtoToModel(dto)).toList();
  }

  /// Load a single example by ID
  Future<void> loadExample(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from cache first for instant display
      final cached = await _localDatasource.getCachedExample(id);
      if (cached != null) {
        _example = _dtoToModel(cached);
        notifyListeners();
      }

      // Fetch from API
      final dto = await _remoteDatasource.getExample(id);
      _example = _dtoToModel(dto);

      // Cache the fresh data
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

  /// Load all examples
  Future<void> loadExamples() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try to load from cache first
      final cached = await _localDatasource.getCachedExamples();
      if (cached.isNotEmpty) {
        _examples = _dtosToModels(cached);
        notifyListeners();
      }

      // Fetch from API
      final dtos = await _remoteDatasource.getExamples();
      _examples = _dtosToModels(dtos);

      // Cache the fresh data
      await _localDatasource.cacheExamples(dtos);

      _error = null;
    } catch (e) {
      _error = e.toString();
      // If API fails and no cache, show error
      if (_examples.isEmpty) {
        _error = 'Failed to load examples. Please check your connection.';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new example
  Future<bool> createExample(ExampleRequestDto request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dto = await _remoteDatasource.createExample(request);
      final model = _dtoToModel(dto);

      // Add to list if loaded
      _examples.add(model);
      await _localDatasource.cacheExample(dto);

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update an existing example
  Future<bool> updateExample(String id, ExampleRequestDto request) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dto = await _remoteDatasource.updateExample(id, request);
      final model = _dtoToModel(dto);

      // Update in list if loaded
      final index = _examples.indexWhere((e) => e.id == id);
      if (index != -1) {
        _examples[index] = model;
      }

      // Update single example if it's the current one
      if (_example?.id == id) {
        _example = model;
      }

      await _localDatasource.cacheExample(dto);

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete an example
  Future<bool> deleteExample(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _remoteDatasource.deleteExample(id);

      // Remove from list
      _examples.removeWhere((e) => e.id == id);

      // Clear if it's the current example
      if (_example?.id == id) {
        _example = null;
      }

      await _localDatasource.clearExampleCache(id);

      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh data
  Future<void> refresh() async {
    if (_example != null) {
      await loadExample(_example!.id);
    } else {
      await loadExamples();
    }
  }
}

