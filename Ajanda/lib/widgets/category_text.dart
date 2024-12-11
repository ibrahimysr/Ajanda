import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/style.dart';

Widget categoryText(Function()? ontap, String title, Color colors) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
            color: colors,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: Text(
                title,
                style: AppStyle.mainContent.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        )),
  );
}
