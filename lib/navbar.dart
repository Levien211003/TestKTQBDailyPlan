import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'list_screen.dart';
import 'favorite_screen.dart';
import 'setting_screen.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int navBarIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      navBarIndex = index;
    });
  }

  // Mảng các màn hình, thêm các màn hình khác nếu cần
  final List<Widget> _screens = [
    HomeScreen(),
    ListScreen(),
    FavoriteScreen(),
    SettingScreen(),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
