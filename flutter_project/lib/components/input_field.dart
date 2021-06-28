import 'package:flutter/material.dart';
import 'package:flutter_project/components/text_field_container.dart';
import 'package:flutter_project/constants.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const InputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kDarkGrayColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kDarkGrayColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}