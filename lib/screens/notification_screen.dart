import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  void _sendTaskReminder(List<Task> tasks) {
    for (var task in tasks) {
      NotificationService().showNotification(
        title: 'Task Reminder',
        body: 'You have a task "${task.taskName}" due today!',
        taskId: task.id, // Pass the task ID
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: taskProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : taskProvider.getTodayTasks().isEmpty
          ? Center(child: Text('No tasks due today.'))
          : ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: taskProvider.getTodayTasks().length,
        itemBuilder: (context, index) {
          final task = taskProvider.getTodayTasks()[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4.0,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 16.0),
              leading: CircleAvatar(
                backgroundColor: Color(0xFF5B0B0E),
                child: Icon(Ionicons.document, color: Colors.white),
              ),
              title: Text(
                task.taskName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(task.description),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final todayTasks = taskProvider.getTodayTasks();
          _sendTaskReminder(todayTasks);
        },
        backgroundColor: Color(0xFF5B0B0E), // Warna latar belakang
        child: Icon(Ionicons.notifications, color: Colors.white), // Warna ikon
        tooltip: 'Send Task Reminders',
      ),
    );
  }

}
