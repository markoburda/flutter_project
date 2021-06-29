import 'package:flutter/material.dart';
import 'package:flutter_project/screens/login/bg.dart';
import 'package:flutter_project/components/login-button.dart';
import 'package:flutter_project/screens/welcome.dart';
import 'package:flutter_project/components/input_field.dart';
import 'package:flutter_project/components/password_field.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('./images/logo_icon.jpg'), height: 100,),
            Text(
              "Deliver.io",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            InputField(
              hintText: "Your Email",
              onChanged: (value) {},
              controller: myController,
            ),
            PasswordField(
              onChanged: (value) {},
              controller: myController,
            ),
            LoginButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
                    },
                  ));
                  }
                  )     
                  ]
      ),
    ));
  }
}