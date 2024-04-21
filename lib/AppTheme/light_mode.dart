import 'package:flutter/material.dart';

ThemeData light_mode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    inversePrimary: Colors.grey.shade900,
  ),
  buttonBarTheme: ButtonBarThemeData(
    buttonTextTheme: ButtonTextTheme.accent,
  ),
);
