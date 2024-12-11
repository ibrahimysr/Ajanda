

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yonetici_paneli/style/database_color.dart';

class AppStyle{ 
  // static TextStyle mainTitle =TextStyle(
  //           fontWeight: FontWeight.w900,
  //           letterSpacing: 0.5,
  //           color: Colors.black,
  //           fontSize: 30
  //         );
static TextStyle mainTitle = GoogleFonts.notoSerif( fontSize: 35, fontWeight: FontWeight.bold,color:textColor);
  // static TextStyle mainContent = TextStyle(
  //           fontWeight: FontWeight.w500,
  //           letterSpacing: 0.5,
  //           color: Colors.black,
  //         );
static TextStyle mainContent = GoogleFonts.notoSerif(fontSize: 18, fontWeight: FontWeight.normal, color: textColor, );
}
  