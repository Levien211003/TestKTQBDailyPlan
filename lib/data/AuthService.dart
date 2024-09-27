import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testktdailyplan/model/task.dart';
import 'package:testktdailyplan/model/user.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.9:7103/api';
  int? _currentUserId; // Biến để lưu ID người dùng hiện tại

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
        _currentUserId = data['user']['userID']; // Lưu vào biến
        await prefs.setInt('userID', _currentUserId!); // Lưu vào SharedPreferences
        return data['user']; // Trả về đối tượng người dùng
      }

      return data; // Trả về thông tin người dùng
    } else {
      return null; // Đăng nhập không thành công
    }
  }

  int? get currentUserId => _currentUserId; // Getter để lấy ID người dùng hiện tại


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

  Future<bool> updateTask(Task task) async {
    // Thực hiện cuộc gọi API để cập nhật công việc
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/Tasks/${task.taskID}'), // Sử dụng taskID từ đối tượng Task
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'TaskID': task.taskID, // Thêm TaskID vào JSON
          'UserID': task.userID, // Thêm UserID
          'Title': task.title, // Thêm Title
          'StartDate': task.startDate.toIso8601String(), // Chuyển đổi DateTime sang ISO 8601
          'EndDate': task.endDate.toIso8601String(), // Chuyển đổi DateTime sang ISO 8601
          'Location': task.location, // Thêm Location
          'AssignedTo': task.assignedTo, // Thêm AssignedTo
          'Status': task.status, // Thêm Status
          'Priority': task.priority, // Thêm Priority
          'Notes': task.notes, // Thêm Notes
        }),
      );

      print('Update Task Response status: ${response.statusCode}'); // Gỡ lỗi phản hồi
      print('Update Task Response body: ${response.body}');

      return response.statusCode == 204; // Trả về true nếu cập nhật thành công
    } catch (e) {
      // Xử lý ngoại lệ
      print('Lỗi khi cập nhật công việc: $e');
      return false;
    }
  }


  // DELETE: Xóa công việc
  Future<bool> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/Tasks/$taskId'),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 204;
  }

  // PUT: Cập nhật ưu tiên của công việc
  Future<bool> updatePriority(int taskId, int priority) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Tasks/$taskId/priority'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(priority), // Gửi giá trị priority dưới dạng body
    );

    // Gỡ lỗi phản hồi
    print('Update Priority Response status: ${response.statusCode}');
    print('Update Priority Response body: ${response.body}');

    return response.statusCode == 204; // Trả về true nếu thành công
  }
}
