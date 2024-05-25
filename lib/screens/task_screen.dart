import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../models/task.dart';
import '../models/category.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deadlineController = TextEditingController();
  int? _selectedCategory;
  String _selectedStatus = 'TO_DO';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final taskData = {
        'task_name': _nameController.text,
        'description': _descriptionController.text,
        'deadline': _deadlineController.text,
        'status': _selectedStatus,
        'category_id': _selectedCategory,
      };

      Provider.of<TaskProvider>(context, listen: false).addTask(taskData);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        automaticallyImplyLeading: false,
      ),
      body: taskProvider.isLoading || categoryProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : taskProvider.tasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return ListTile(
            title: Text(task.taskName),
            subtitle: Text(task.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditTaskDialog(task, categoryProvider.categories);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _confirmDeleteTask(task);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(categoryProvider.categories),
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }

  void _showAddTaskDialog(List<Category> categories) {
    _nameController.clear();
    _descriptionController.clear();
    _deadlineController.clear();
    _selectedCategory = categories.isNotEmpty ? categories.first.id : null;
    _selectedStatus = 'TO_DO';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Task'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
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
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: 'Deadline'),
                readOnly: true,
                onTap: () => _selectDeadline(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deadline';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['TO_DO', 'IN_PROGRESS', 'DONE'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
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
            onPressed: _submitForm,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(Task task, List<Category> categories) {
    _nameController.text = task.taskName;
    _descriptionController.text = task.description;
    _deadlineController.text = task.deadline;
    _selectedCategory = task.categoryId;
    _selectedStatus = task.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task name';
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
              TextFormField(
                controller: _deadlineController,
                decoration: InputDecoration(labelText: 'Deadline'),
                readOnly: true,
                onTap: () => _selectDeadline(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a deadline';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category.categoryName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['TO_DO', 'IN_PROGRESS', 'DONE'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
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
              final taskData = {
                'task_name': _nameController.text,
                'description': _descriptionController.text,
                'deadline': _deadlineController.text,
                'status': _selectedStatus,
                'category_id': _selectedCategory!,
              };

              Provider.of<TaskProvider>(context, listen: false)
                  .updateTask(task.id, taskData)
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

  void _confirmDeleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id)
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
