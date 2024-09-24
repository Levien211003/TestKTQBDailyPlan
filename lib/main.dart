import 'package:flutter/material.dart';
import 'package:testktdailyplan/login_screen.dart';
import 'navbar.dart'; // Import Navbar

void main() {
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
