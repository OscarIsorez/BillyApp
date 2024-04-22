class Message {
  final SenderType sender;
  final String content;
  final DateTime timestamp;

  Message(
      {required this.sender, required this.content, required this.timestamp});

  toJson() {
    return {
      'sender': senderTypeToString,
      'content': content,
      'timestamp': timestamp,
    };
  }

  String get senderTypeToString {
    switch (sender) {
      case SenderType.user:
        return 'user';
      case SenderType.system:
        return 'system';
      case SenderType.bot:
        return 'bot';
    }
  }
}

enum SenderType {
  user,
  system,
  bot,
}
