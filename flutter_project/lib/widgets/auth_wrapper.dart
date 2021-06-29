import 'package:flutter/material.dart';
import 'package:flutter_project/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/screens/login-page.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    if (user != null) {
      return HomeScreen();
    }
    return LoginScreen();
  }
}
