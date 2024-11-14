import 'dart:math';
import 'package:flutter/material.dart';

// 随机生成一个颜色值
Color get randomColor {
  final Random random = Random();
  return Color.fromARGB(
    255, // Alpha value (opacity)
    random.nextInt(256), // Red value
    random.nextInt(256), // Green value
    random.nextInt(256), // Blue value
  );
}

class CPTextStyles {
  static const TextStyle title = TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);
  static const TextStyle label = TextStyle(color: Color(0xff656565), fontSize: 16, fontWeight: FontWeight.bold);
  static const TextStyle body = TextStyle(color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.bold);
}
