import 'package:flutter/material.dart';

Image LogoWidget(String imageName) {
  return Image.asset(
    imageName,
    width: 400,
    height: 300,
    color: Colors.white,
  );
}

Color hexToColor(String hexCode) {
  return Color(int.parse(hexCode, radix: 16) + 0xFF000000);
}
