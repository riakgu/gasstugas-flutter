import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class AuthService {
  final String baseUrl = Config.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['token']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(Map<String, String> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      body: user,
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> logout() async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.clear();
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/auth'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, String> userData) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/auth/update-profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: userData,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return data;
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/auth/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'current_password': currentPassword,
        'password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }
}
