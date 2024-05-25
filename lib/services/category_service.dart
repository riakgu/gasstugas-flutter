import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../config/config.dart';

class CategoryService {
  final String baseUrl = Config.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Category>> getCategories() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> createCategory(Map<String, String> category) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(category),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<Category> updateCategory(int id, Map<String, String> category) async {
    final token = await _getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(category),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Category.fromJson(data);
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
