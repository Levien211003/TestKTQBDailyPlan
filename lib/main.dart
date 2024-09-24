import 'package:flutter/material.dart';
import 'navbar.dart'; // Import Navbar

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navbar(), // Đặt Navbar là màn hình chính
    );
  }
}
