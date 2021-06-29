import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_project/components/password_field.dart';
import 'package:flutter_project/components/login-button.dart';
import 'package:flutter_project/components/text_field_container.dart';
import 'package:flutter_project/widgets/auth_service.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  static const routename = '/signup';
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    TextEditingController confirmPassController = new TextEditingController();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            TextFieldContainer(
                child: TextField(
              controller: emailController,
              onChanged: (value) {},
              cursorColor: kDarkGrayColor,
              decoration: InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
              ),
            )),
            TextFieldContainer(
                child: TextField(
              controller: passwordController,
              onChanged: (value) {},
              cursorColor: kDarkGrayColor,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: InputBorder.none,
              ),
            )),
            TextFieldContainer(
                child: TextField(
              controller: confirmPassController,
              onChanged: (value) {},
              obscureText: true,
              cursorColor: kDarkGrayColor,
              decoration: InputDecoration(
                hintText: 'Confirm password',
                border: InputBorder.none,
              ),
            )),
            LoginButton(
              text: "SIGN UP",
              press: () {
                if (passwordController.text
                        .compareTo(confirmPassController.text) !=
                    0) {
                  Fluttertoast.showToast(
                      msg: 'Password does not match',
                      gravity: ToastGravity.TOP);
                } else {
                  context.read<AuthenticationService>().signUp(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim());
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/');
                }
              },
            ),
          ]),
    ));
  }
}
