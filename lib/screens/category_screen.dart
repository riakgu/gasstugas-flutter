import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final categoryData = {
        'category_name': _nameController.text,
        'description': _descriptionController.text,
      };

      Provider.of<CategoryProvider>(context, listen: false)
          .addCategory(categoryData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: categoryProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : categoryProvider.categories.isEmpty
              ? Center(child: Text('No categories available.'))
              : ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4.0,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF5B0B0E),
                          child: Icon(Iconsax.category_2, color: Colors.white),
                        ),
                        title: Text(
                          category.categoryName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(category.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Iconsax.edit_2_copy,
                                  color: Colors.lightBlue),
                              onPressed: () {
                                _showEditCategoryDialog(category);
                              },
                            ),
                            IconButton(
                              icon: Icon(Ionicons.trash_bin, color: Colors.red),
                              onPressed: () {
                                _confirmDeleteCategory(category);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5B0B0E),
        onPressed: _showAddCategoryDialog,
        child: Icon(Ionicons.add_sharp, color: Colors.white),
        tooltip: 'Add Category',
      ),
    );
  }

  void _showAddCategoryDialog() {
    _nameController.clear();
    _descriptionController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 80, 36, 36),
        title: Text('Add Category', style: TextStyle(color: Colors.white)),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Category Name',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white)),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: _submitForm,
            child: Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(Category category) {
    _nameController.text = category.categoryName;
    _descriptionController.text = category.description;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Category'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Category Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final categoryData = {
                'category_name': _nameController.text,
                'description': _descriptionController.text,
              };

              Provider.of<CategoryProvider>(context, listen: false)
                  .updateCategory(category.id, categoryData)
                  .then((_) {
                Navigator.pop(context);
              });
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Category'),
        content: Text('Are you sure you want to delete this category?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<CategoryProvider>(context, listen: false)
                  .deleteCategory(category.id)
                  .then((_) {
                Navigator.pop(context);
              });
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
