import 'package:flutter/material.dart';

class ColorConverter {
  static Map<String, Color> get colorMap => _colorMap;

  static final Map<String, Color> _colorMap = {
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'black': Colors.black,
    'white': Colors.white,
    'orange': Colors.orange,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'brown': Colors.brown,
    'cyan': Colors.cyan,
    'indigo': Colors.indigo,
    'lime': Colors.lime,
    'teal': Colors.teal,
    'amber': Colors.amber,
    'deepOrange': Colors.deepOrange,
    'deepPurple': Colors.deepPurple,
    'lightBlue': Colors.lightBlue,
    'lightGreen': Colors.lightGreen,
    'blueGrey': Colors.blueGrey,
    'grey': Colors.grey,
    'magenta': const Color(0xFFFF00FF), // Magenta (no built-in constant)
    'violet': const Color(0xFF8A2BE2), // BlueViolet (no built-in constant)
    'gold': const Color(0xFFFFD700), // Gold (no built-in constant)
    'silver': const Color(0xFFC0C0C0), // Silver (no built-in constant)
    'navy': const Color(0xFF000080), // Navy (no built-in constant)
    'maroon': const Color(0xFF800000), // Maroon (no built-in constant)
    'olive': const Color(0xFF808000), // Olive (no built-in constant)
    'aqua': const Color(0xFF00FFFF), // Aqua (no built-in constant)
    'coral': const Color(0xFFFF7F50), // Coral (no built-in constant)
    'khaki': const Color(0xFFF0E68C), // Khaki (no built-in constant)
  };

  static Color? getColorFromString(String colorName) {
    return _colorMap[colorName];
  }
}
// Ví dụ
// String colorString = 'Colors.blue';
//     Color? color = ColorConverter.getColorFromString(colorString);
//     color: color ?? Colors.grey