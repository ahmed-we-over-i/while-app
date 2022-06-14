import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:while_app/presentation/screens/enums.dart';

class CustomTheme {
  final Color backgroundColor;
  final Color bottomColor;
  final Color foregroundColor;

  CustomTheme({required this.backgroundColor, required this.bottomColor, required this.foregroundColor});
}

CustomTheme GetColors(ColorTheme theme, ColorMode mode) {
  switch (theme) {
    case ColorTheme.grey:
      if (mode == ColorMode.light) {
        return CustomTheme(backgroundColor: Color(0xFFE6EEF2), bottomColor: Color(0xFFACB9BF), foregroundColor: Color(0xFF212626));
      } else {
        return CustomTheme(backgroundColor: Color(0xFF3B4545), bottomColor: Color(0xFF212626), foregroundColor: Color(0xFFACB9BF));
      }
    case ColorTheme.blue:
      if (mode == ColorMode.light) {
        return CustomTheme(backgroundColor: Color(0xFFB2FBFF), bottomColor: Color(0xFF52C6CC), foregroundColor: Color(0xFF274A4D));
      } else {
        return CustomTheme(backgroundColor: Color(0xFF30686B), bottomColor: Color(0xFF274A4D), foregroundColor: Color(0xFF52C6CC));
      }
    case ColorTheme.yellow:
      if (mode == ColorMode.light) {
        return CustomTheme(backgroundColor: Color(0xFFF4F7AD), bottomColor: Color(0xFFB9BF4D), foregroundColor: Color(0xFF4B4D27));
      } else {
        return CustomTheme(backgroundColor: Color(0xFF686B30), bottomColor: Color(0xFF4B4D27), foregroundColor: Color(0xFFB9BF4D));
      }
    case ColorTheme.red:
      if (mode == ColorMode.light) {
        return CustomTheme(backgroundColor: Color(0xFFFFB2BF), bottomColor: Color(0xFFBF4D60), foregroundColor: Color(0xFF4D262D));
      } else {
        return CustomTheme(backgroundColor: Color(0xFF6B303A), bottomColor: Color(0xFF4D262D), foregroundColor: Color(0xFFBF4D60));
      }
  }
}
