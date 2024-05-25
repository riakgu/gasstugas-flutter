import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../utils/snackbar.dart';

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
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _authService.login(email, password);
      _user = data['user'];
      _isAuthenticated = true;
      await loadProfile(); // Ensure state consistency by loading profile after login
      showSnackBar('Login successful!');
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      showSnackBar(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(Map<String, String> user) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _authService.register(user);
      showSnackBar(data['message'] ?? 'Registration successful!');
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _isAuthenticated = false;
      _user = null;
      showSnackBar('Logout successful!');
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _authService.getProfile();
      _user = data;
      _isAuthenticated = true;
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      showSnackBar(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, String> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _authService.updateProfile(userData);
      _user = data;
      showSnackBar('Profile updated successfully!');
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.changePassword(currentPassword, newPassword);
      showSnackBar('Password changed successfully!');
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
