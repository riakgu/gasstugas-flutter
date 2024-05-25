import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasks(); // Fetch tasks after the first frame is rendered
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final taskProvider = Provider.of<TaskProvider>(context);

    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Error: User data is null')),
      );
    }

    final todayTasks = taskProvider.getTodayTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tasks Due Today',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 150, // Height for the horizontal list
            child: taskProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : todayTasks.isEmpty
                ? Center(child: Text('No tasks due today.'))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: todayTasks.length,
              itemBuilder: (context, index) {
                final task = todayTasks[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.8, // Full screen width
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.taskName,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: Text(task.description, maxLines: 3, overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(height: 8),
                          Text('Status: ${task.status}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'App Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3, // Number of columns
              children: [
                _buildFeatureItem(context, Icons.chat, 'Chatbot', '/chatbot'),
                _buildFeatureItem(context, Icons.category, 'Category', '/categories'),
                if (user['role'] == 'admin')
                  _buildFeatureItem(context, Icons.people, 'Users', '/users'), // Only show for admins
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.blue), // Adjust icon size here
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
