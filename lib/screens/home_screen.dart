import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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
      taskProvider
          .fetchTasks(); // Fetch tasks after the first frame is rendered
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final taskProvider = Provider.of<TaskProvider>(context);

    final todayTasks = taskProvider.getTodayTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        automaticallyImplyLeading: false,
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
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color:
                                  Color(0xFF5B0B0E), // Warna untuk kotak Card
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.taskName,
                                      style: TextStyle(
                                        color: Colors.white, // Warna teks
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Expanded(
                                      child: Text(
                                        task.description,
                                        style: TextStyle(
                                          color: Colors.white, // Warna teks
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Status: ${task.status}',
                                      style: TextStyle(
                                        color: Colors.white, // Warna teks
                                      ),
                                    ),
                                     SizedBox(height: 8),
                                    Text(
                                      'Waktu: ${task.deadline}',
                                      style: TextStyle(
                                        color: Colors.white, // Warna teks
                                      ),
                                    ),
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
                _buildFeatureItem(
                    context, Iconsax.message_2, 'Chatbot', '/chatbot'),
                _buildFeatureItem(
                    context, Iconsax.category_2, 'Category', '/categories'),
                _buildFeatureItem(context, Iconsax.map_1_copy, 'Map', '/map'),
                if (user?['role'] == 'admin')
                  _buildFeatureItem(context, Iconsax.people, 'Users', '/users'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
      BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.grey[200],
                  border: Border.all(
                      color: Color(
                          0xFF5B0B0E)), // Warna abu-abu pada pinggiran kotak
                ),
              ),
              Icon(icon,
                  size: 25,
                  color: Color(0xFF5B0B0E)), // Sesuaikan ukuran ikon di sini
            ],
          ),
          SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}
