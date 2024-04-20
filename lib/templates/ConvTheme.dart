import 'package:billy/templates/ConversationType.dart';

class ConvTheme {
  final ConversationType type;
  final String sysPrompt;

  ConvTheme({required this.type, required this.sysPrompt});

  @override
  String toString() {
    return type.toString();
    ;
  }
}
