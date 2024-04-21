import 'package:billy/constant.dart';
import 'package:billy/templates/ConvTheme.dart';
import 'package:billy/templates/Conversation.dart';
import 'package:billy/templates/ConversationType.dart';
import 'package:billy/templates/Message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LlmApiManager with ChangeNotifier {
  final String _baseUrl = 'https://api.mistral.ai/v1/chat/completions';
  final String _apiKey = 'YOUR_API';

  String result = '';
  get results => result;

  /// Gets the response from the LLM API for the given message.
  ///
  /// This method sends the provided message to the LLM API using the [sendMessage] method, and returns the response received from the API.
  ///
  /// Parameters:
  /// - `message`: The message to send to the LLM API.
  ///
  /// Returns:
  /// The response received from the LLM API.
  Future<String> getResponse(String message) async {
    await sendMessage('You are an helpful assistant', message);
    return result;
  }

  /// Corrects a message by sending it to the LLM API and returning the result.
  ///
  /// This method sends the provided message to the LLM API, along with a correction system prompt, and returns the result from the API response.
  ///
  /// Parameters:
  /// - `message`: The message to be corrected.
  ///
  /// Returns:
  /// The corrected message from the LLM API response.
  Future<String> correctMessage(String message) async {
    String correctionSystemPrompt = Constants.correctionSystemPrompt;
    sendMessage(correctionSystemPrompt, message);
    return result;
  }

  /// Sends a message to the LLM API and updates the result.
  ///
  /// This method sends a POST request to the LLM API with the provided message. The API response is then parsed and the result is stored in the `result` field. Listeners are notified of the updated result.
  ///
  /// Parameters:
  /// - `message`: The message to send to the LLM API.
  Future<void> sendMessage(String systemPrompt, String message) async {
    final url = _baseUrl;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer Sjkb9UoiCs5vvToxHmUtX0TQw46nr9Rn',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'mistral-tiny',
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': message},
        ],
        'max_tokens': 60,
        'temperature': '0.5',
      }),
    );

    if (response.statusCode == 200) {
      result = jsonDecode(response.body)['choices'][0]['message']['content'];
      notifyListeners();
    } else {
      result = 'Failed to send message';
    }
  }
}
