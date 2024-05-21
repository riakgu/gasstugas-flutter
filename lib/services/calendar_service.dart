import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CalendarService {
  final String baseUrl = 'http://gasstugas.riakgu.dev/api';

  Future<Map<DateTime, List<Map<String, dynamic>>>> fetchCalendarEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

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
