import 'package:billy/Message.dart';

class Conversation {
  List<Message> _messages = [];

  // Get the list of messages
  List<Message> get messages => _messages;

  // Add a message to the conversation
  void addMessage(Message message) {
    _messages.add(message);
  }

  // Get the conversation history
  String getHistory() {
    return _messages.map((message) {
      return '${message.timestamp}: ${message.sender} - ${message.content}';
    }).join('\n');
  }
}