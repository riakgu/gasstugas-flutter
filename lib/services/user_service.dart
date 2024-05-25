import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../config/config.dart';

class UserService {
  final String baseUrl = Config.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<User>> getUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('GET /users response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(Map<String, String> userData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: userData,
    );
    print('POST /users response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return User.fromJson(data);
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(int id, Map<String, String> userData) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: userData,
    );
    print('PUT /users/$id response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return User.fromJson(data);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('DELETE /users/$id response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
