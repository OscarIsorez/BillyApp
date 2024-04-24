import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:billy/templates/Message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationProvider with ChangeNotifier {
  Conversation conversation = Conversation(
    name: 'Test Conversation',
    theme: ConvTheme(type: ConversationType.noTheme),
    messages: [],
  );

  List<Message> get messages => conversation.messages;

  void setConversation(Conversation conversation) {
    this.conversation = conversation;

    notifyListeners();
  }

  void addMessage(String message) {
    conversation.messages.add(
      Message(sender: SenderType.user, content: message),
    );
    notifyListeners();
  }

  String encodeMessage(
    String content,
    String sender,
  ) {
    /**
       * This function is used to encode the message to be sent to the API
      */
    var message = {
      'role': sender,
      'content': content,
    };

    return jsonEncode(message);
  }

  String decodeMessage(String message) {
    /**
       * This function is used to decode the message received from the API
      */
    var decodedMessage = jsonDecode(message);
    return decodedMessage['content'];
  }

  String encodeAllMessages() {
    /**
       * This function is used to encode all the messages to be sent to the API
      */
    var allMessages = [];
    for (var message in conversation.messages) {
      allMessages
          .add(encodeMessage(message.content, message.senderTypeToString));
    }
    return jsonEncode(allMessages);
  }

  Future<void> fetchResponse() async {
    print(conversation.theme.sysPrompt);
    // print("the prompt is ${jsonEncode(conversation.messages)}");
    var url = 'https://api.mistral.ai/v1/chat/completions';
    var headers = {
      'Authorization': 'Bearer Sjkb9UoiCs5vvToxHmUtX0TQw46nr9Rn',
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'model': 'mistral-tiny',
      'messages': [
        {'role': 'system', 'content': conversation.theme.sysPrompt},
        {'role': 'user', 'content': encodeAllMessages()}
      ],
      'max_tokens': 60,
      'temperature': '0.5',
    });

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    var data = jsonDecode(response.body);

    print(data['choices'][0]);
    addMessage(data['choices'][0]['message']['content']);
  }

  void clearMessages() {
    conversation.messages.clear();
    notifyListeners();
  }

  void removeMessage(int index) {
    conversation.messages.removeAt(index);
    notifyListeners();
  }

  Message? getLastMessage() {
    if (conversation.messages.isEmpty) {
      return null;
    }
    return conversation.messages.last;
  }
}
