import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _userService.getUsers();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(Map<String, String> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await _userService.createUser(userData);
      _users.add(newUser);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(int id, Map<String, String> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await _userService.updateUser(id, userData);
      final index = _users.indexWhere((user) => user.id == id);
      _users[index] = updatedUser;
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.deleteUser(id);
      _users.removeWhere((user) => user.id == id);
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
