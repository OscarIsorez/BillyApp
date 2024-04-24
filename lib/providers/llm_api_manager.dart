import 'package:billy/constant.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LlmApiManager {
  final String _baseUrl = 'https://api.mistral.ai/v1/chat/completions';

  String result = '';

  String showResult(String message) {
    getCorrectedMessage(message);
    String tmp = result;
    result = '';
    return tmp;
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
  Future<String> getCorrectedMessage(String message) async {
    String correctionSystemPrompt = Constants.correctionSystemPrompt;
    String correctedMessage =
        await sendMessage(correctionSystemPrompt, message);

    return correctedMessage;  
  }

  /// Sends a message to the LLM API and updates the result.
  ///
  /// This method sends a POST request to the LLM API with the provided message. The API response is then parsed and the result is stored in the `result` field. Listeners are notified of the updated result.
  ///
  /// Parameters:
  /// - `message`: The message to send to the LLM API.
  Future<String> sendMessage(String systemPrompt, String message) async {
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
    } else {
      result = 'Failed to send message';
    }
    return result;
  }
}
