import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'list_screen.dart';
import 'challenge_screen.dart';
import 'setting_screen.dart';

class Navbar extends StatefulWidget {
  final int userId; // Thêm tham số userId

  Navbar({required this.userId}); // Thay đổi hàm khởi tạo để yêu cầu userId

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int navBarIndex = 0;
  bool isDarkMode = false; // Trạng thái dark mode ban đầu

  void _onItemTapped(int index) {
    setState(() {
      navBarIndex = index;
    });
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value; // Cập nhật trạng thái dark mode
    });
  }

  // Mảng các màn hình, thêm các màn hình khác nếu cần
  List<Widget> get _screens => [
    HomeScreen(isDarkMode: isDarkMode, userId: widget.userId), // Truyền tham số userId
    ListScreen(isDarkMode: isDarkMode, userId: widget.userId), // Truyền tham số isDarkMode
    ChallengeScreen(isDarkMode: isDarkMode), // Truyền tham số isDarkMode
    SettingScreen(isDarkMode: isDarkMode, onDarkModeChanged: _toggleDarkMode), // Truyền tham số và callback
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[navBarIndex], // Hiển thị màn hình dựa trên navBarIndex
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navBarIndex,
        backgroundColor: Color(0xFF44462E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Lịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Công Việc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Thử Thách',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cài Đặt',
          ),
        ],
      ),
    );
  }
}
