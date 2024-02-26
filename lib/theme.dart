import 'package:flutter/material.dart';

ThemeData generatePurpleTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
    useMaterial3: true,
  );
}

ThemeData generateDarkPurpleTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurpleAccent,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
