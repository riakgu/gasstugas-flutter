import 'package:flutter/material.dart';
import '../services/calendar_service.dart';

class CalendarProvider with ChangeNotifier {
  final CalendarService _calendarService = CalendarService();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  bool _isLoading = false;

  Map<DateTime, List<Map<String, dynamic>>> get events => _events;
  bool get isLoading => _isLoading;

  CalendarProvider() {
    loadEvents();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _events.clear();
      _events = await _calendarService.fetchCalendarEvents();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }
}
