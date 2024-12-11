 import 'package:flutter/material.dart';
import 'package:yonetici_paneli/style/style.dart';

Widget addTaskTextfield(String label, TextEditingController controller, String hintText, int flex,context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              
  
              style: AppStyle.mainContent,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: const Color(0xff282C34),
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget addTaskTextfield2(String label, TextEditingController controller, String hintText, int flex,context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(

               maxLines: null, // Çok satırlı metin için
            minLines: 1, // Minimum satır sayısı
              style: AppStyle.mainContent,
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                fillColor: const Color(0xff282C34),
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }