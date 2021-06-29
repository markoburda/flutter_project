import 'package:flutter/material.dart';
import 'package:flutter_project/constants.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const LoginButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = kPrimaryLightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(
                fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          ),
          onPressed: () {
            press();
          },
          child: const Text('LOGIN'),
        ),
      ),
    );
  }
}
