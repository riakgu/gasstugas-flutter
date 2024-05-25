import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/calendar_provider.dart';
import 'providers/category_provider.dart';
import 'providers/task_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/category_screen.dart';
import 'screens/task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'GasstuGas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isLoading) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (authProvider.isAuthenticated) {
                return MainScreen();
              }
              return LoginScreen();
            },
          ),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
          '/main': (context) => MainScreen(),
          '/chatbot': (context) => ChatbotScreen(),
          '/calendar': (context) => CalendarScreen(),
          '/categories': (context) => CategoryScreen(),
          '/tasks': (context) => TaskScreen(),
        },
      ),
    );
  }
}
