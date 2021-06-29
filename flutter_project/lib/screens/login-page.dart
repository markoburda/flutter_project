import 'package:flutter/material.dart';
import 'package:flutter_project/components/input_field.dart';
import 'package:flutter_project/components/password_field.dart';
import 'package:flutter_project/components/login_button.dart';
import 'package:flutter_project/screens/sign_up_screen.dart';
import 'package:flutter_project/widgets/auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/logo_icon.jpg'),
              height: 100,
            ),
            Text(
              "Deliver.io",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            InputField(
              hintText: "Your Email",
              onChanged: (value) {},
              controller: emailController,
            ),
            PasswordField(
                onChanged: (value) {}, controller: passwordController),
            LoginButton(
              text: "LOGIN",
              press: () {
                context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim());
              },
            ),
            InkWell(
              child: Text('Sign up'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SignUpScreen.routename);
              },
            )
          ]),
    ));
  }
}
