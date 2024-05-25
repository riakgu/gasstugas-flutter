import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _taskService.getTasks();
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Task> getTodayTasks() {
    final today = DateTime.now();
    return _tasks.where((task) {
      final deadline = DateTime.parse(task.deadline);
      return deadline.year == today.year && deadline.month == today.month && deadline.day == today.day;
    }).toList();
  }

  Future<void> addTask(Map<String, String> taskData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTask = await _taskService.createTask(taskData);
      _tasks.add(newTask);
    } catch (e) {
      print('Error adding task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(int id, Map<String, String> taskData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedTask = await _taskService.updateTask(id, taskData);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    } catch (e) {
      print('Error updating task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _taskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
    } catch (e) {
      print('Error deleting task: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
