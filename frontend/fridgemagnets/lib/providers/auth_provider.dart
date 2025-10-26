import 'package:flutter/material.dart';
import 'package:fridgemagnets/services/auth_service.dart';
import 'package:fridgemagnets/services/shared_prefs_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _token;
  String? _username;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get username => _username;
  String? get errorMessage => _errorMessage;

  // Constructor - attempt to fetch token
  AuthProvider() {
    _token = SharedPrefsService().getString("token");
  }

  /// ---- Internal helpers ----
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// ---- Register ----
  Future<void> register(String username, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      await _authService.register(username, password);
      // optionally auto-login here if desired
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ---- Login ----
  Future<void> login(String username, String password) async {
    _setLoading(true);
    _setError(null);
    try {
      final token = await _authService.login(username, password);
      _token = token;
      _username = await _authService.getUserName(token);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ---- Get username from token ----
  Future<void> fetchUser(String token) async {
    _setLoading(true);
    _setError(null);
    try {
      _username = await _authService.getUserName(token);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ---- Delete account ----
  Future<void> deleteAccount() async {
    if (_token == null) return;
    _setLoading(true);
    _setError(null);
    try {
      await _authService.deleteAccount(_token);
      _token = null;
      _username = null;
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// ---- Logout ----
  void logout() {
    _token = null;
    SharedPrefsService.instance.remove("token");
    _username = null;
    notifyListeners();
  }
}