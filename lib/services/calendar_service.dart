import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';

class CalendarService {
  final String baseUrl = Config.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<DateTime, List<Map<String, dynamic>>>> fetchCalendarEvents() async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/calendar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['events'] as Map<String, dynamic>;
      return data.map<DateTime, List<Map<String, dynamic>>>((key, value) {
        final date = DateTime.parse(key);
        final events = List<Map<String, dynamic>>.from(value);
        return MapEntry(DateTime.utc(date.year, date.month, date.day), events);
      });
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message']);
    }
  }
}
