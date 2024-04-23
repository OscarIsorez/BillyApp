class Message {
  final SenderType sender;
  final String content;

  Message({required this.sender, required this.content});

  toJson() {
    return {
      'sender': senderTypeToString,
      'content': content,
    };
  }

  static fromJson(Map<String, dynamic> json) {
    return Message(
      sender: json['sender'] == 'user'
          ? SenderType.user
          : json['sender'] == 'system'
              ? SenderType.system
              : SenderType.bot,
      content: json['content'],
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
