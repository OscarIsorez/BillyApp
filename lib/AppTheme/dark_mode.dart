import 'package:flutter/material.dart';

ThemeData dark_mode = ThemeData(
  colorScheme: ColorScheme.dark(
      background: Colors.grey.shade900,
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade800,
      inversePrimary: Colors.grey.shade300),
  buttonBarTheme: ButtonBarThemeData(
    buttonTextTheme: ButtonTextTheme.accent,
  ),
);