import 'package:billy/templates/ConversationType.dart';

class ConvTheme {
  final ConversationType type;
  final String sysPrompt;

  ConvTheme({required this.type, required this.sysPrompt});

  @override
  String toString() {
    return type.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is ConvTheme) {
      return type == other.type;
    }
    return false;
  }

  // fromString
  static ConvTheme fromString(String type) {
    switch (type) {
      case 'ConversationType.Normal':
        return ConvTheme(type: ConversationType.Normal, sysPrompt: '');
      case 'ConversationType.Bakery':
        return ConvTheme(type: ConversationType.Bakery, sysPrompt: '');
      case 'ConversationType.Bank':
        return ConvTheme(type: ConversationType.Bank, sysPrompt: '');
      default:
        return ConvTheme(type: ConversationType.Normal, sysPrompt: '');
    }
  }
}
