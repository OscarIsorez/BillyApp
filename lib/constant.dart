import 'dart:io';

import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:flutter/material.dart';

class Constants {
  static const int maxAttempts = 3;
  static const double pi = 3.14159;
  static const String appName = "MyApp";
  // ignore: non_constant_identifier_names
  static const SenderColorMessage = Color(0xFF5381A7);
  // ignore: non_constant_identifier_names
  static const ReceiverColorMessage = Color.fromARGB(255, 212, 111, 111);

  static const List<String> themes = [
    'Theme 1',
    'Theme 2',
    'Theme 3',
  ];

  static List<ConvTheme> convThemes = [
    //  type : normal, sysPrompt le contenu du fichier lib\prompts\no_theme.txt
    ConvTheme(type: ConversationType.Normal),
    ConvTheme(type: ConversationType.Bakery),
    ConvTheme(type: ConversationType.Bank)
  ];

  
}
