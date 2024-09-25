import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testktdailyplan/model/user.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.1.9:7103/api/User';

  // Phương thức đăng ký người dùng
  Future<String?> registerUser(User user) async {
    final Map<String, dynamic> userData = {
      'Email': user.email,
      'Password': user.password,
      'StudentID': user.studentID,
      'Name': user.name,
      'Language': user.language,  // Thêm trường language
    };

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
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
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Email': email,
        'Password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Lưu token vào SharedPreferences
      final data = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data; // Trả về thông tin người dùng
    } else {
      return null; // Đăng nhập không thành công
    }
  }
}
