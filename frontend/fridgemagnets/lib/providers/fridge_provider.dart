import 'package:flutter/material.dart';
import 'package:fridgemagnets/models/fridge.dart';
import 'package:fridgemagnets/services/fridge_service.dart';

class FridgeProvider extends ChangeNotifier {
  final FridgeService _fridgeService = FridgeService();

  List<Fridge> _fridges = [];
  bool _isLoading = false;
  bool _hasFetched = false;
  String? _errorMessage;

  List<Fridge> get fridges => _fridges;
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Fetch list of fridges for a specific username
  Future<void> fetchFridgesByUsername(String username) async {
    if (_hasFetched) return; // prevent multiple calls
    _hasFetched = true;
    _setLoading(true);
    _setError(null);

    try {
      final fetchedFridges = await _fridgeService.getFridgesByUsername(username);
      _fridges = fetchedFridges;
      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new fridge
  Future<void> createFridge(String token, String name, String username) async {
    _setLoading(true);
    _setError(null);

    try {
      await _fridgeService.createFridge(token, name, username);
      _fridges.add(Fridge(name: name, magnets: []));
      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a fridge
  Future<void> deleteFridge(String token, Fridge fridge) async {
    _setLoading(true);
    _setError(null);

    try {
      await _fridgeService.deleteFridge(token, fridge);
      _fridges.removeWhere((f) => f.id == fridge.id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }
}