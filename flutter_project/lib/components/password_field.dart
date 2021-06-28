import 'package:flutter/material.dart';
import 'package:flutter_project/components/text_field_container.dart';
import 'package:flutter_project/constants.dart';

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const PasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kDarkGrayColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kDarkGrayColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kDarkGrayColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}