import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';

Widget settingTextfield(
    TextEditingController controller, Icon icon, String data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: Text(
          data,
          style: AppStyle.mainContent,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: enabledColor.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            icon: icon,
            iconColor: enabledColor,
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ),
      ),
    ],
  );
}
