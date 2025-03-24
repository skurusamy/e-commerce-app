import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String name;
  final String hintText;
  final bool obscureText;
  final dynamic validator;

  const CustomTextFormField(
      {Key? key,
        required this.name,
        this.controller,
      required this.hintText,
        this.validator,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ), name: name,
    );
  }
}
