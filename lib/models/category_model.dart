import 'package:flutter/material.dart';

class Category {
  final String name;
  final Icon icon;
  final Color iconColor;

  Category(this.name, this.icon, this.iconColor);

  static Category fromMap(Map<String, dynamic> map) {
    return Category(
        map['name'],
        Icon(IconData(map['icon'], fontFamily: 'MaterialIcons'),
            color: Color(map['color'])),
        Color(map['color']));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.icon.codePoint,
      'color': iconColor.value
    };
  }
}
