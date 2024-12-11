import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import '../style/style.dart';

Widget loginTextField(TextEditingController controller, String title, Icon icon,
    bool open, String data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        data,
        style: AppStyle.mainContent,
      ),
      const SizedBox(
        height: 8,
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:const BorderRadius.only(
              topLeft: Radius.circular(10),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
            ),
            border: Border.all(color: textColor)),
        child: TextField(
          obscureText: open,
          controller: controller,
          style: const TextStyle(color: appcolor),
          decoration: InputDecoration(
              icon: icon,
              iconColor: enabledColor,
              border: InputBorder.none,
              hintText: title,
              hintStyle: const TextStyle(color: Colors.grey)),
        ),
      ),
    ],
  );
}
