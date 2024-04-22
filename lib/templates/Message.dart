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

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] == 'user'
          ? SenderType.user
          : json['sender'] == 'system'
              ? SenderType.system
              : SenderType.bot,
      content: json['content'],
      timestamp: json['timestamp'],
    );
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
