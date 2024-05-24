import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.getCategories();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(Map<String, String> categoryData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newCategory = await _categoryService.createCategory(categoryData);
      _categories.add(newCategory);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(int id, Map<String, String> categoryData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedCategory = await _categoryService.updateCategory(id, categoryData);
      final index = _categories.indexWhere((category) => category.id == id);
      _categories[index] = updatedCategory;
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _categoryService.deleteCategory(id);
      _categories.removeWhere((category) => category.id == id);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
