import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:testktdailyplan/model/user.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.9:7103/api';

  Future<String?> registerUser(User user) async {
    final Map<String, dynamic> userData = {
      'Email': user.email,
      'Password': user.password,
      'StudentID': user.studentID,
      'Name': user.name,
      'Language': user.language,  // Thêm trường language
    };

    final response = await http.post(
      Uri.parse('$baseUrl/Users/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    // Gỡ lỗi phản hồi
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return 'User registered successfully!';
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  // Phương thức đăng nhập
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Users/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Email': email,
        'Password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Lưu token và userID vào SharedPreferences
      final data = jsonDecode(response.body);
      print(data); // Kiểm tra dữ liệu nhận được từ API
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);

      // Lưu userID
      if (data['user']['userID'] != null) {
        await prefs.setInt('userID', data['user']['userID']);
        return data['user']; // Trả về đối tượng người dùng
      }

      return data; // Trả về thông tin người dùng
    } else {
      return null; // Đăng nhập không thành công
    }
  }

  // GET: Lấy danh sách công việc của người dùng
  Future<List<Task>?> getTasksByUser(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/Tasks/user/$userId'));

    if (response.statusCode == 200) {
      final List<dynamic> taskJson = jsonDecode(response.body);
      return taskJson.map((json) => Task.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  // POST: Thêm công việc mới
  Future<bool> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    // Gỡ lỗi phản hồi
    print('Add Task Response status: ${response.statusCode}');
    print('Add Task Response body: ${response.body}');

    return response.statusCode == 201; // Trả về true nếu thành công
  }

  // GET: Lấy công việc theo ID
  Future<Task?> getTaskById(int taskId) async {
    final response = await http.get(Uri.parse('$baseUrl/tasks/$taskId'));

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // PUT: Chỉnh sửa công việc
  Future<bool> updateTask(int taskId, Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    return response.statusCode == 204;
  }

  // DELETE: Xóa công việc
  Future<bool> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 204;
  }
}
