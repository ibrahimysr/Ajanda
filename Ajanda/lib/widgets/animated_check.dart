import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class AnimatedCheckIcon extends StatelessWidget {
  final String title;
  const AnimatedCheckIcon({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/$title.json', // Lottie dosyanızın yolunu buraya ekleyin
      width: 150,
      height: 150,
    );
  }
}
