import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    _requestPermissions();
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    required int taskId,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'gasstugas_channel_id',
      'GasstuGas Notifications',
      channelDescription: 'Channel untuk notifikasi GasstuGas',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      taskId,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> scheduleDailyTaskReminders(List<Task> tasks) async {
    tz.initializeTimeZones();
    final location = tz.getLocation('Asia/Jakarta'); // Set lokasi ke WIB

    for (var task in tasks) {
      final now = tz.TZDateTime.now(location);
      final taskDeadline = DateTime.parse(task.deadline);

      if (taskDeadline.year != now.year ||
          taskDeadline.month != now.month ||
          taskDeadline.day != now.day) {
        continue;
      }

      var scheduledTime = tz.TZDateTime(
        location,
        tz.TZDateTime.now(location).year,
        tz.TZDateTime.now(location).month,
        tz.TZDateTime.now(location).day,
        7, 0, 0, // Jam 7:00 AM
      );

      if (scheduledTime.isBefore(now)) {
        // Jika sudah lewat jam 7 pagi, kirim notifikasi langsung
        showNotification(
          title: 'Task Reminder',
          body: 'You have a task "${task.taskName}" due today!',
          taskId: task.id,
        );
      } else {
        // Jika belum lewat jam 7 pagi, jadwalkan notifikasi
        await flutterLocalNotificationsPlugin.zonedSchedule(
          task.id,
          'Task Reminder',
          'You have a task "${task.taskName}" due today!',
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'gasstugas_channel_id',
              'GasstuGas Notifications',
              channelDescription: 'Channel untuk notifikasi GasstuGas',
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // Ulangi setiap hari pada jam yang sama
        );
      }

    }
  }
}
