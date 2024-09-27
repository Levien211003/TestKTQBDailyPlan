import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testktdailyplan/model/taskreminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ReminderService {
  static const String baseUrl = 'http://192.168.1.9:7103/api/reminder';

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Constructor để khởi tạo plugin
  ReminderService() {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Đảm bảo có icon hợp lệ

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  // GET: Lấy danh sách nhắc nhở
  Future<List<TaskReminder>?> getReminders() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> reminderJson = jsonDecode(response.body);
      return reminderJson.map((json) => TaskReminder.fromMap(json)).toList();
    } else {
      return null;
    }
  }

  // GET: Lấy nhắc nhở theo ID
  Future<TaskReminder?> getReminderById(int reminderId) async {
    final response =
    await http.get(Uri.parse('$baseUrl/reminderId/$reminderId'));

    if (response.statusCode == 200) {
      return TaskReminder.fromMap(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // POST: Tạo nhắc nhở mới
  Future<bool> createReminder(TaskReminder reminder) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reminder.toMap()),
    );

    return response.statusCode == 201; // Trả về true nếu tạo thành công
  }

  // PUT: Cập nhật nhắc nhở
  Future<bool> updateReminder(TaskReminder reminder) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${reminder.reminderID}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reminder.toMap()),
    );

    return response.statusCode == 204; // Trả về true nếu cập nhật thành công
  }

  // DELETE: Xóa nhắc nhở
  Future<bool> deleteReminder(int reminderId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$reminderId'),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 204; // Trả về true nếu xóa thành công
  }

  // Hàm để lên lịch nhắc nhở
  Future<void> scheduleTaskReminder(int reminderId, String title, DateTime reminderTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      reminderId, // ID duy nhất cho mỗi nhắc nhở
      'Nhắc nhở công việc', // Tiêu đề thông báo
      title, // Nội dung thông báo
      tz.TZDateTime.from(reminderTime, tz.local), // Chuyển đổi DateTime thành TZDateTime
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Nhắc nhở công việc',
          channelDescription: 'Kênh cho nhắc nhở công việc',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // Hàm hủy nhắc nhở theo reminderId
  Future<void> cancelTaskReminder(int reminderId) async {
    await flutterLocalNotificationsPlugin.cancel(reminderId);
  }
}
