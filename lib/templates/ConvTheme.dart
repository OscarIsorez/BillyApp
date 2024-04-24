import 'package:billy/constant.dart';
import 'package:billy/templates/ConversationType.dart';

/// Returns a string representation of the [ConvTheme] type.
///
/// The object is constructed with a [ConversationType] type, and the [sysPrompt] field is set
/// ex : ConvTheme(type: ConversationType.Normal) , sysPrompt = Constants.noThemePrompt
class ConvTheme {
  final ConversationType type;
  late String sysPrompt;

  ConvTheme({required this.type}) {
    sysPrompt = getSysPrompt();
  }

  String getSysPrompt() {
    switch (type) {
      case ConversationType.noTheme:
        return Constants.noThemePrompt;
      case ConversationType.Bakery:
        return Constants.bakeryPrompt;
      case ConversationType.Bank:
        return Constants.bankPrompt;
    }
  }

  @override

  /// Returns a string representation of the [ConvTheme] type.
  ///
  /// The returned string will be one of 'Normal', 'Bakery', or 'Bank', depending on the
  /// value of the [type] field.
  String toString() {
    switch (type) {
      case ConversationType.noTheme:
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
  /// with the [ConversationType.noTheme] type will be returned.
  static ConvTheme fromString(String type) {
    switch (type) {
      case 'Normal':
        return ConvTheme(type: ConversationType.noTheme);
      case 'Bakery':
        return ConvTheme(type: ConversationType.Bakery);
      case 'Bank':
        return ConvTheme(type: ConversationType.Bank);
      default:
        return ConvTheme(type: ConversationType.noTheme);
    }
  }
}
