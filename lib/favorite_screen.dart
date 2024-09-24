import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Favorite'),
      //   backgroundColor: Colors.green, // Màu của AppBar
      // ),
      body: Center(
        child: Text('Welcome to the Favorite Screen'),
      ),
    );
  }
}
