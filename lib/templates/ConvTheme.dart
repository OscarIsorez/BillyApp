import 'dart:io';

import 'package:billy/templates/ConversationType.dart';

class ConvTheme {
  final ConversationType type;
  late String sysPrompt;

  ConvTheme({required this.type}) {
    sysPrompt = getContenu(
        'lib/prompts/${type.toString().split('.').last.toLowerCase()}.txt');
  }

  String getContenu(String path) {
    final file = File(path);
    if (file.existsSync()) {
      return file.readAsStringSync();
    } else {
      return 'File not found';
    }
  }

  @override

  /// Returns a string representation of the [ConvTheme] type.
  ///
  /// The returned string will be one of 'Normal', 'Bakery', or 'Bank', depending on the
  /// value of the [type] field.
  String toString() {
    switch (type) {
      case ConversationType.Normal:
        return 'Normal';
      case ConversationType.Bakery:
        return 'Bakery';
      case ConversationType.Bank:
        return 'Bank';
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is ConvTheme) {
      return type == other.type;
    }
    return false;
  }

  /// Constructs a [ConvTheme] instance from a string representation of the conversation type.
  ///
  /// The string can be one of 'Normal', 'Bakery', or 'Bank', and the corresponding [ConvTheme] instance
  /// will be returned. If the string does not match any of the valid types, a [ConvTheme] instance
  /// with the [ConversationType.Normal] type will be returned.
  static ConvTheme fromString(String type) {
    switch (type) {
      case 'Normal':
        return ConvTheme(type: ConversationType.Normal);
      case 'Bakery':
        return ConvTheme(type: ConversationType.Bakery);
      case 'Bank':
        return ConvTheme(type: ConversationType.Bank);
      default:
        return ConvTheme(type: ConversationType.Normal);
    }
  }
}
