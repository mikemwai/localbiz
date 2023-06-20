import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray600 = fromHex('#797979');

  static Color blueGray100 = fromHex('#d1d1d1');

  static Color black900 = fromHex('#000000');

  static Color blueGray400 = fromHex('#888888');

  static Color pinkA400 = fromHex('#ff014d');

  static Color blueGray10001 = fromHex('#d9d9d9');

  static Color orange600Cc = fromHex('#ccf88500');

  static Color gray200 = fromHex('#e8e8e8');

  static Color whiteA700 = fromHex('#ffffff');

  static Color red500Cc = fromHex('#ccff4141');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
