import 'package:flutter/material.dart';

class CustomInputFieldWidget extends StatelessWidget {
  String hintText = "";
  TextEditingController? controller;
  Function(String)? onChanged;
  bool enabled;
  
  CustomInputFieldWidget({
    Key? key,
    this.hintText = "",
    this.controller,
    this.onChanged,
    this.enabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        disabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 4.0,
        ),
      ),
    );
  }
}
