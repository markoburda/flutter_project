import 'package:flutter/material.dart';
import 'package:flutter_project/components/text_field_container.dart';
import 'package:flutter_project/constants.dart';

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const PasswordField({
    Key? key,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: this.controller,
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
