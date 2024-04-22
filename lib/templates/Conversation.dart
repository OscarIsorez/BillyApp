import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Message.dart';

class Conversation {
  List<Message> _messages = [];
  final String name;
  final ConvTheme theme;

  // Constructor
  Conversation({required this.name, required this.theme});

  // Get the list of messages
  List<Message> get messages => _messages;

  // Add a message to the conversation
  void addMessage(Message message) {
    _messages.add(message);
  }

  Message? getLastMessage() {
    if (_messages.isEmpty) {
      return null;
    }
    return _messages.last;
  }

  SenderType? getLastSender() {
    if (_messages.isEmpty) {
      return null;
    }
    return _messages.last.sender;
  }

  String getHistory() {
    return _messages.map((message) {
      return '${message.timestamp}: ${message.sender} - ${message.content}';
    }).join('\n');
  }

  toJson() {
    return {
      'name': name,
      'theme': theme.toString(),
      'messages': _messages.map((message) => message.toJson()).toList(),
    };
  }
}
