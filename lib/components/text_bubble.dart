import 'package:flutter/material.dart';
import 'package:billy/constant.dart';

class TextBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const TextBubble({
    Key? key,
    required this.message,
    required this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // minHeight: 50,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isSender
                ? Constants.SenderColorMessage
                : Constants.ReceiverColorMessage,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              if (isSender)
                IconButton(
                  onPressed: () {
                    // on ouvre un dialog avec les details du message
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Message Details'),
                          content: Text(message),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
