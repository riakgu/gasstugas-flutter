import 'package:flutter/material.dart';
import '../services/calendar_service.dart';

class CalendarProvider with ChangeNotifier {
  final CalendarService _calendarService = CalendarService();
  Map<DateTime, List<Map<String, dynamic>>> _events = {};
  bool _isLoading = true;

  Map<DateTime, List<Map<String, dynamic>>> get events => _events;
  bool get isLoading => _isLoading;

  CalendarProvider() {
    loadEvents();  // Initially load events from the API
  }

  void loadDummyEvents() {
    _events = {
      DateTime.utc(2024, 5, 20): [
        {
          'task_name': 'Task 1',
          'category': 'Work',
          'description': 'Work on project',
          'deadline': '2024-05-20',
          'status': 'TO_DO',
        },
      ],
      DateTime.utc(2024, 5, 31): [
        {
          'task_name': 'Task 2',
          'category': 'Personal',
          'description': 'Buy groceries',
          'deadline': '2024-05-31',
          'status': 'TO_DO',
        },
      ],
    };
    print('Dummy Events Loaded: $_events');
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadEvents() async {
    try {
      _events = await _calendarService.fetchCalendarEvents();
      print('Events Loaded from API: $_events');
    } catch (e) {
      print('Error Loading Events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }
}
