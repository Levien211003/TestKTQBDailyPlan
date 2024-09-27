import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import cho thông báo
import 'package:testktdailyplan/login_screen.dart';
import 'navbar.dart'; // Import Navbar

// Tạo đối tượng FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Hàm khởi tạo thông báo
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // Icon thông báo

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo widget đã sẵn sàng
  initializeNotifications(); // Khởi tạo thông báo khi app khởi chạy
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
