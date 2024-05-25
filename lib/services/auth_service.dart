import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class AuthService {
  final String baseUrl = Config.baseUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', data['data']['token']);
      return data;
    } else {
      throw Exception(data['message']);
    }
  }

  Future<Map<String, dynamic>> register(Map<String, String> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      body: user,
    );

    final data = json.decode(response.body);
    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      prefs.remove('token');
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/auth'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data['data'];
    } else {
      throw Exception(data['message']);
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, String> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/auth/update-profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: userData,
    );

    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return data['data'];
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$baseUrl/auth/change-password'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );

    if (response.statusCode != 200) {
      final data = json.decode(response.body);
      throw Exception(data['message']);
    }
  }
}
