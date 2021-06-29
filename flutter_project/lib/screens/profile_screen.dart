import 'package:flutter/material.dart';
import 'package:flutter_project/screens/main_drawer.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      drawer: MainDrawer(),
      body: Center(child: Text('HI')),
    );
  }
}
