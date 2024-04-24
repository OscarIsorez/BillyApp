import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Message.dart';


class Conversation {
  List<Message> messages;
  String name;
  final ConvTheme theme;

  setName(String name) {
    this.name = name;
  }

  // Constructor
  Conversation({
    required this.name,
    required this.theme,
    required this.messages,
  });

  // Get the list of messages

  // Add a message to the conversation
  void addMessage(Message message) {
    messages.add(message);
  }

  Message? getLastMessage() {
    if (messages.isEmpty) {
      return null;
    }
    return messages.last;
  }

  SenderType? getLastSender() {
    if (messages.isEmpty) {
      return null;
    }
    return messages.last.sender;
  }

  String getHistory() {
    return messages.map((message) {
      return '${message.sender} - ${message.content}';
    }).join('\n');
  }

  toJson() {
    return {
      'name': name,
      'theme': theme.toString(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return Conversation(
      name: json['name'],
      theme: ConvTheme.fromString(json['theme']),
      messages: (json['messages'] as List)
          .map<Message>((dynamic message) =>
              Message.fromJson(message as Map<String, dynamic>))
          .toList(),
    );
  }
}
