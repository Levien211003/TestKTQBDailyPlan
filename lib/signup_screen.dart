  import 'dart:convert';
  import 'package:flutter/gestures.dart';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'login_screen.dart';
  
  class SignupScreen extends StatefulWidget {
    @override
    _SignupScreenState createState() => _SignupScreenState();
  }
  
  class _SignupScreenState extends State<SignupScreen> {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _languageController = TextEditingController();
    final TextEditingController _studentIdController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    String? _selectedLanguage = 'vi';

    Future<void> _register() async {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mật khẩu không khớp')),
        );
        return;
      }

      final url = Uri.parse('http://192.168.1.9:7103/api/User/register');

      // Tạo một đối tượng JSON từ các trường thông tin
      final Map<String, dynamic> data = {
        'Name': _nameController.text,
        'Language': _selectedLanguage!,
        'StudentID': _studentIdController.text,
        'Email': _emailController.text,
        'Password': _passwordController.text,
      };

      // Gửi yêu cầu POST với JSON
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',  // Đảm bảo thông báo đúng định dạng
        },
        body: jsonEncode(data),  // Chuyển đổi dữ liệu thành JSON
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: ${response.reasonPhrase}')),
        );
      }
    }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Color(0xFF212020),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 40),
                _buildTitle('Mời Nhập Thông Tin'),
                SizedBox(height: 20),
                _buildForm(),
                SizedBox(height: 20),
                _buildTermsAndPolicy(),
                SizedBox(height: 20),
                _buildSignupButton(),
                SizedBox(height: 10),
                _buildLoginPrompt(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }
  
    Widget _buildHeader() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'Tạo Tài Khoản',
            style: TextStyle(
              color: Color(0xFFE2F163),
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }
  
    Widget _buildTitle(String title) {
      return Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      );
    }
  
    Widget _buildForm() {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF44462E),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            _buildLanguageDropdown(),
            _buildTextField('Student ID', _studentIdController),
            _buildTextField('Email', _emailController),
            _buildTextField('Password', _passwordController, obscureText: true),
            _buildTextField('Confirm Password', _confirmPasswordController, obscureText: true),
          ],
        ),
      );
    }
  
    Widget _buildLanguageDropdown() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          DropdownButton<String>(
            value: _selectedLanguage,
            dropdownColor: Color(0xFF44462E),
            style: TextStyle(color: Colors.white),
            underline: Container(
              height: 2,
              color: Color(0xFFE2F163),
            ),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLanguage = newValue!;
                _languageController.text = _selectedLanguage!;
              });
            },
            items: <String>['vi', 'en']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value == 'vi' ? 'Tiếng Việt' : 'English'),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
        ],
      );
    }
  
    Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    }
  
    Widget _buildTermsAndPolicy() {
      return Column(
        children: [
          Text(
            'Bằng việc đăng ký, bạn đồng ý với các điều khoản và chính sách của chúng tôi.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  
    Widget _buildSignupButton() {
      return ElevatedButton(
        onPressed: _register,
        child: Text('Đăng Ký'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE2F163),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        ),
      );
    }
  
    Widget _buildLoginPrompt() {
      return RichText(
        text: TextSpan(
          text: 'Bạn đã có tài khoản? ',
          style: TextStyle(color: Colors.white),
          children: <TextSpan>[
            TextSpan(
              text: 'Đăng Nhập',
              style: TextStyle(color: Color(0xFFE2F163)),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
            ),
          ],
        ),
      );
    }
  }
