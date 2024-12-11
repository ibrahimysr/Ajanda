import 'package:flutter/material.dart';

Widget taskTextField(
  TextEditingController controller,
  String title,
) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black)),
    child: TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          iconColor: Colors.white,
          border: InputBorder.none,
          hintText: title,
          hintStyle: const TextStyle(color: Colors.grey)),
    ),
  );
}
