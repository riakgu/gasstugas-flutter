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
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(Map<String, String> taskData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTask = await _taskService.createTask(taskData);
      _tasks.add(newTask);
    } catch (e) {
      print(e);
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
      _tasks[index] = updatedTask;
    } catch (e) {
      // Handle error
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
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
