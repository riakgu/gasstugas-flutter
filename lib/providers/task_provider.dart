import 'package:flutter/material.dart';
import 'package:gasstugas_flutter/services/notification_service.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../utils/snackbar.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _taskService = TaskService();
  final NotificationService _notificationService= NotificationService();
  List<Task> _tasks = [];
  List<Task> _todayTasks = [];
  List<Task> _incompleteTasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  List<Task> get todayTasks => _todayTasks;
  List<Task> get incompleteTasks => _incompleteTasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _taskService.getTasks();
      _todayTasks = getTodayTasks();
      _incompleteTasks = getIncompleteTasks();
    } catch (e) {
      showSnackBar('Failed to fetch tasks: ${e.toString()}');
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

  List<Task> getIncompleteTasks() {
    return _todayTasks.where((task) => task.status != 'DONE').toList();
  }

  Future<void> addTask(Map<String, dynamic> taskData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTask = await _taskService.createTask(taskData);
      _tasks.add(newTask);
      showSnackBar('Task added successfully!');
    } catch (e) {
      print(e);
      showSnackBar('Failed to add task: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> taskData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedTask = await _taskService.updateTask(id, taskData);
      final index = _tasks.indexWhere((task) => task.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      showSnackBar('Task updated successfully!');
    } catch (e) {
      showSnackBar('Failed to update task: ${e.toString()}');
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
      showSnackBar('Task deleted successfully!');
    } catch (e) {
      showSnackBar('Failed to delete task: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
