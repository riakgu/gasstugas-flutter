import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _user;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider() {
    loadProfile();
  }

  Future<void> login(String email, String password) async {
    try {
      final data = await _authService.login(email, password);
      _user = data['data']['user'];
      _isAuthenticated = true;
      notifyListeners();
      // Load profile after login to ensure state consistency
      await loadProfile();
    } catch (e) {
      throw e;
    }
  }

  Future<void> register(Map<String, String> user) async {
    try {
      await _authService.register(user);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> loadProfile() async {
    try {
      final data = await _authService.getProfile();
      _user = data;
      _isAuthenticated = true;
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, String> userData) async {
    try {
      final data = await _authService.updateProfile(userData);
      _user = data;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _authService.changePassword(currentPassword, newPassword);
    } catch (e) {
      throw e;
    }
  }
}
