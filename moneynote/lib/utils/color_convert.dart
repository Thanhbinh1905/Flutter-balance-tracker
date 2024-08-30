import 'package:flutter/material.dart';

class ColorConverter {
  static final Map<String, Color> _colorMap = {
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'black': Colors.black,
    'white': Colors.white,
    // Thêm các màu khác ở đây
  };

  static Color? getColorFromString(String colorName) {
    return _colorMap[colorName];
  }
}
// Ví dụ
// String colorString = 'Colors.blue';
//     Color? color = ColorConverter.getColorFromString(colorString);
//     color: color ?? Colors.grey