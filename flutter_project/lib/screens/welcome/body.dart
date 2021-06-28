import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login-page.dart';
import 'package:flutter_project/screens/welcome/bg.dart';
import 'package:flutter_project/components/login-button.dart';
import 'package:flutter_project/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "HELLO WORLD",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}