import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';

Widget loginButton(String title, Function()? ontap) {
  return SizedBox(
    width: 300,
    height: 65,
    child: ElevatedButton(
      onPressed: ontap,
      style: ElevatedButton.styleFrom(
        side: const BorderSide(width: 2, color: appcolor2),
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )),
        backgroundColor: enabledColor,
      ),
      child: Text(
        title,
        style: AppStyle.mainContent.copyWith(color: appcolor, fontSize: 20),
      ),
    ),
  );
}
