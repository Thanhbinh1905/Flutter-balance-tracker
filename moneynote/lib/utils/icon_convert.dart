import 'package:flutter/material.dart';

class IconConverter {
  static final Map<String, IconData> _incomeIconMap = {
    'star': Icons.star,
    'wifi': Icons.wifi,
    // Add more icons here
  };

  static final Map<String, IconData> _outcomeIconMap = {
    'add': Icons.add,
    'remove': Icons.remove,
    // Add more icons here
  };

  static IconData? getIconDataFromString(String iconName,
      {bool isIncome = true}) {
    if (isIncome) {
      return _incomeIconMap[iconName];
    } else {
      return _outcomeIconMap[iconName];
    }
  }
}
  // Ví dụ sử dụng
  // String iconString = 'Icons.wifi';
  // IconData? iconData = IconConverter.getIconDataFromString(iconString);
  // Icon(iconData ?? Icons.error) // Hiển thị biểu tượng mặc định nếu không tìm thấy